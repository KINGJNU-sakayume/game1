import { useState } from 'react'
import { LocateFixed, MapPin, Navigation } from 'lucide-react'
import { director } from '../../engine/director'
import { useGame } from '../../engine/store'
import type { ChoiceOption } from '../../engine/store'
import { PLACES, isPlaceId } from '../../story/places'
import type { PlaceId } from '../../story/places'
import { formatDay } from '../../state/gameClock'
import { ChoicePrompt, ExtraChoices, splitOptions, useAppChoice } from '../../components/appChoice'
import './map.css'

const ALL_PLACES = Object.keys(PLACES) as PlaceId[]

/** 망원동을 단순하게 그린 바탕 (도로·시장·공원·한강) */
function MapBase() {
  return (
    <g aria-hidden>
      <rect width="360" height="440" fill="var(--map-land)" />
      {/* 블록 */}
      <g fill="var(--map-block)">
        <rect x="8" y="90" width="50" height="52" rx="6" />
        <rect x="80" y="92" width="58" height="50" rx="6" />
        <rect x="160" y="90" width="64" height="52" rx="6" />
        <rect x="8" y="164" width="48" height="36" rx="6" />
        <rect x="80" y="166" width="56" height="34" rx="6" />
        <rect x="248" y="166" width="36" height="34" rx="6" />
        <rect x="8" y="232" width="46" height="40" rx="6" />
        <rect x="78" y="234" width="56" height="38" rx="6" />
        <rect x="160" y="234" width="60" height="40" rx="6" />
        <rect x="250" y="236" width="80" height="34" rx="6" />
        <rect x="8" y="296" width="48" height="28" rx="6" />
        <rect x="160" y="298" width="56" height="26" rx="6" />
      </g>
      {/* 한강공원과 한강 */}
      <path d="M0 336 L360 372 L360 402 L0 368 Z" fill="var(--map-park)" />
      <path d="M0 368 L360 402 L360 440 L0 440 Z" fill="var(--map-water)" />
      {/* 골목 */}
      <g stroke="var(--map-road)" strokeWidth="5" strokeLinecap="round" fill="none">
        <path d="M70 70 L62 332" />
        <path d="M150 70 L140 332" />
        <path d="M18 150 L332 158" />
        <path d="M18 280 L342 290" />
        <path d="M200 152 L216 190" />
        <path d="M230 262 L360 318" />
      </g>
      {/* 큰길 */}
      <g stroke="var(--map-road-edge)" strokeWidth="11" strokeLinecap="round" fill="none">
        <path d="M0 64 L360 64" />
        <path d="M238 64 L230 332" />
        <path d="M0 208 L360 224" />
        <path d="M0 330 L360 366" />
      </g>
      <g stroke="var(--map-road-major)" strokeWidth="8" strokeLinecap="round" fill="none">
        <path d="M0 64 L360 64" />
        <path d="M0 330 L360 366" />
      </g>
      <g stroke="var(--map-road)" strokeWidth="7" strokeLinecap="round" fill="none">
        <path d="M238 64 L230 332" />
        <path d="M0 208 L360 224" />
      </g>
      {/* 망원시장 (지붕 덮인 골목) */}
      <path d="M300 76 L294 192" stroke="var(--map-market)" strokeWidth="14" strokeLinecap="round" />
      <g className="map-road-label">
        <text x="16" y="58">월드컵로</text>
        <text x="244" y="112" transform="rotate(88 244 112)">망원로</text>
        <text x="16" y="202" transform="rotate(2.5 16 202)">포은로</text>
        <text x="236" y="352" transform="rotate(5.7 236 352)">강변북로</text>
        <text x="250" y="428" className="map-road-label--water">한강</text>
      </g>
    </g>
  )
}

interface PinProps {
  id: PlaceId
  here: boolean
  pick: ChoiceOption | undefined
  selected: boolean
  onSelect: (id: PlaceId) => void
}

function Pin({ id, here, pick, selected, onSelect }: PinProps) {
  const place = PLACES[id]
  const right = place.x > 250
  const classes = ['map-pin', pick ? 'is-pick' : '', selected ? 'is-selected' : '', place.known ? 'is-landmark' : '']
  return (
    <g
      className={classes.join(' ')}
      transform={`translate(${place.x} ${place.y})`}
      onClick={() => onSelect(id)}
      role="button"
      aria-label={`${place.name}${pick ? ', 갈 수 있는 곳' : ''}${here ? ', 지금 여기' : ''}`}
    >
      <circle r="18" fill="transparent" />
      {pick && <circle className="map-pin__pulse" r="10" />}
      {here && <circle className="map-pin__here" r="11" />}
      <circle className="map-pin__dot" r={pick || selected ? 7 : 5.5} />
      <text className="map-pin__label" x={right ? -10 : 10} y="4" textAnchor={right ? 'end' : 'start'}>
        {place.name}
      </text>
    </g>
  )
}

/** 지도: 드러난 장소와 지금 위치. 갈 곳을 고르는 선택(# go:)이 뜨면 그 장소들이 반짝인다 */
export default function MapApp() {
  const choice = useAppChoice('map')
  const pins = useGame((s) => s.journal.pins)
  const location = useGame((s) => s.journal.location)
  const visits = useGame((s) => s.journal.visits)
  const [selected, setSelected] = useState<PlaceId | null>(null)
  const { main, extra } = splitOptions(choice)
  const picks = main.filter((o) => o.ref && isPlaceId(o.ref))
  const pickOf = (id: PlaceId) => picks.find((o) => o.ref === id)

  const shown = ALL_PLACES.filter(
    (id) => PLACES[id].known || pins.includes(id) || id === location || pickOf(id) !== undefined,
  )
  const current = location && isPlaceId(location) ? location : null
  const focus = selected ?? null
  const focusVisits = focus ? visits.filter((v) => v.place === focus) : []

  return (
    <div className="map">
      <div className="map__canvas">
        <svg viewBox="0 0 360 440" role="img" aria-label="망원동 지도">
          <MapBase />
          {shown.map((id) => (
            <Pin key={id} id={id} here={id === current} pick={pickOf(id)} selected={id === focus} onSelect={setSelected} />
          ))}
        </svg>
      </div>

      <section className="map__sheet">
        {choice ? (
          <>
            <ChoicePrompt choice={choice} app="map" />
            <ul className="map__picks">
              {picks.map((o) => {
                const place = PLACES[o.ref as PlaceId]
                return (
                  <li key={o.index}>
                    <button type="button" className="map__pick" onClick={() => director.choose(o.index)}>
                      <span className="map__pick-icon">
                        <Navigation size={18} aria-hidden />
                      </span>
                      <span className="map__pick-text">
                        <span className="map__pick-name">{o.label}</span>
                        <span className="map__pick-sub">{o.label === place.name ? place.sub : place.name}</span>
                      </span>
                    </button>
                  </li>
                )
              })}
            </ul>
            <ExtraChoices options={extra} />
          </>
        ) : focus ? (
          <div className="map__info">
            <p className="map__info-name">
              <MapPin size={18} aria-hidden /> {PLACES[focus].name}
            </p>
            <p className="map__info-sub">{PLACES[focus].sub}</p>
            {focusVisits.length > 0 ? (
              <ul className="map__visits">
                {[...focusVisits].reverse().map((v, i) => (
                  <li key={i}>
                    <span className="map__visit-when">
                      {formatDay(v.day).replace(/ \S+요일$/, '')} {v.time}
                    </span>
                    {v.note && <span className="map__visit-note">{v.note}</span>}
                  </li>
                ))}
              </ul>
            ) : (
              <p className="map__info-empty">아직 가 본 적 없는 곳</p>
            )}
          </div>
        ) : (
          <p className="map__hint">
            <LocateFixed size={16} aria-hidden /> 지금 여기: {current ? PLACES[current].name : '알 수 없음'}
            <span>핀을 누르면 다녀온 기록이 보입니다</span>
          </p>
        )}
      </section>
    </div>
  )
}
