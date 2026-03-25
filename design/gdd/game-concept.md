# Game Concept: Extraction Protocol

*Created: 2026-03-26*
*Status: Draft*

---

## Elevator Pitch

> It's a space resource-management roguelite where you build a deep-space mining
> installation whose production structures ARE your defense — when the waves hit,
> your factory fights back.

---

## Core Identity

| Aspect | Detail |
| ---- | ---- |
| **Genre** | Resource management / Roguelite strategy |
| **Platform** | PC |
| **Target Audience** | Systems-minded players who love mastery and optimization |
| **Player Count** | Single-player |
| **Session Length** | 30-60 minutes per run |
| **Monetization** | Premium (no micro-transactions) |
| **Estimated Scope** | Small (weeks to MVP, months to full vision) |
| **Comparable Titles** | Into the Breach, Mindustry, Slay the Spire |

---

## Core Fantasy

You are the sole operator of a deep-space automated mining installation on a
hostile asteroid. There is no army. There are no soldiers. There is only the
colony you build.

Every structure you place extracts resources AND has a secondary defensive
property — solar arrays emit electromagnetic pulses, fuel refineries explode on
impact, ore processors generate blast barriers. When the hostile waves arrive,
you don't switch modes. You don't build turrets. Your factory defends itself.

The fantasy: **your production colony is terrifying.** The "aha" moment isn't
"I built good towers" — it's "I built a brilliant factory that *also happens* to
be an impenetrable killzone." Mastery is learning which economic configurations
accidentally produce devastating defensive geometries.

---

## Unique Hook

> "It's like a tower defense, AND ALSO every structure you place is also a
> production building — there are no pure defense structures. Your economy IS
> your defense."

This passes the "and also" test and is genuinely novel: most hybrid
economy/defense games (Mindustry, Sanctum) still let you place dedicated
defensive structures. Extraction Protocol does not. Every placement decision
is simultaneously economic and defensive. There is no separation.

---

## Player Experience Analysis (MDA Framework)

### Target Aesthetics (What the player FEELS)

| Aesthetic | Priority | How We Deliver It |
| ---- | ---- | ---- |
| **Sensation** (sensory pleasure) | 3 | Sci-fi glow effects, satisfying resource flow animations, particle feedback |
| **Fantasy** (make-believe, role-playing) | 4 | Lone operator of a deep-space installation; the colony is an extension of the player |
| **Narrative** (drama, story arc) | N/A | No story — the systems tell the story |
| **Challenge** (obstacle course, mastery) | 1 | Difficulty curve, emergent defensive geometry, boss counter-build puzzles |
| **Fellowship** (social connection) | N/A | Single-player only |
| **Discovery** (exploration, secrets) | 2 | Discovering synergistic building combos, emergent defensive patterns, roguelite variety |
| **Expression** (self-expression, creativity) | 4 | Build variety — multiple valid colony configurations per run |
| **Submission** (relaxation, comfort zone) | N/A | Not this game |

### Key Dynamics (Emergent player behaviors)

- Players will experiment with building placement to discover emergent defensive
  geometries (e.g., "a ring of solar arrays creates a pulse kill zone")
- Players will develop personal "build orders" and refine them across runs
- Players will recognize boss types early and pivot their economic strategy to
  counter the incoming threat
- Players will share colony screenshots and configurations with other players

### Core Mechanics (Systems we build)

1. **Dual-purpose building placement** — Each building has an economic output
   rate and a passive defensive property. Players place buildings on a grid.
2. **Resource flow visualization** — Resources visibly flow between nodes.
   Players watch output rates and bottlenecks in real time.
3. **Wave resolution** — Every N rounds, a wave attacks along defined vectors.
   Player makes 2-3 light tactical decisions (redirect a pulse, trigger a
   detonation, reinforce a sector). The economy absorbs the attack.
4. **Boss encounters (every 5 waves)** — A boss with specific attack patterns
   that reward specific counter-configurations. Previewed one wave in advance.
5. **Roguelite run variety** — Each run randomizes starting resources, asteroid
   map layout, and available building options. No two runs play identically.

---

## Player Motivation Profile

### Primary Psychological Needs Served

| Need | How This Game Satisfies It | Strength |
| ---- | ---- | ---- |
| **Autonomy** (freedom, meaningful choice) | No correct build order — multiple valid strategies per run; roguelite variety ensures builds feel like the player's own | Supporting |
| **Competence** (mastery, skill growth) | Build order mastery, combo discovery, boss counter-build knowledge all compound over runs | Core |
| **Relatedness** (connection, belonging) | Minimal — single-player. Community sharing of colony screenshots provides weak relatedness signal | Minimal |

### Player Type Appeal (Bartle Taxonomy)

- [x] **Achievers** (goal completion, collection, progression) — How: Boss clears, run victories, personal best wave counts, unlock progression
- [x] **Explorers** (discovery, understanding systems, finding secrets) — How: Discovering building synergies, emergent defensive combos, roguelite variety
- [ ] **Socializers** (relationships, cooperation, community) — Not a focus
- [ ] **Killers/Competitors** (domination, PvP, leaderboards) — Possible leaderboard addition in full release, not MVP

### Flow State Design

- **Onboarding curve**: First run uses a fixed asteroid layout with 3 buildings
  available. Tutorial text is embedded in the UI, not a cutscene. Player is
  building within 60 seconds.
- **Difficulty scaling**: Wave difficulty scales with run progress. Later runs
  (after first boss clear) introduce more complex asteroid layouts and building
  restrictions.
- **Feedback clarity**: Resource flow rates are always visible. After each wave,
  a brief "damage report" shows which buildings absorbed hits and which defensive
  properties activated. Player can always reconstruct what happened.
- **Recovery from failure**: Runs are 30-60 minutes. Failure returns immediately
  to the run start screen. No punishment screens — just "Wave X — Build again."

---

## Core Loop

### Moment-to-Moment (30 seconds)
Watching resource nodes fill up, deciding: upgrade this producer, extend this
chain, or bank resources for the wave? The idle-game heartbeat of watching numbers
tick combined with the strategic weight of placement decisions.

### Short-Term (5-15 minutes)
One complete cycle: ~3-minute economy phase → wave resolution → salvage/repair →
back to building. The "one more cycle" hook lives here — you always want to extend
your chain before the next wave.

### Session-Level (30-60 minutes)
Waves 1–5 → Boss 1 → Waves 6–10 → Boss 2 → etc. A full run has a clear arc:
early expansion, mid-game optimization, late-game crisis management. Boss
previews create intentional pivots in strategy.

### Long-Term Progression
Roguelite unlocks: clearing bosses unlocks new building types available in future
runs. Mastery accrues as players learn which building combinations beat which boss
types. "Build order theory" deepens across dozens of runs.

### Retention Hooks

- **Curiosity**: "What does a cluster of fuel refineries do against the next boss
  type? I need to try that."
- **Investment**: The unlocked building roster grows with each boss clear —
  players want to try new combos unlocked last run.
- **Mastery**: Personal best wave count, faster boss clears, more efficient
  economic configurations.

---

## Game Pillars

### Pillar 1: Readable Systems
Economic flows are always visible and legible. The player always knows WHY
something happened — why a wave killed them, why a building is underperforming,
why a resource chain is bottlenecked.

*Design test*: If we're debating between a complex mechanic that creates
interesting emergent behavior vs. a simpler mechanic whose effects are
immediately legible, choose legibility. Complexity that can't be read is
frustration, not depth.

### Pillar 2: Dual-Purpose Everything
Every structure has both an economic output role and a defensive property.
No pure defense structures exist. No pure production structures exist.

*Design test*: If we're designing a new building and can only think of its
defensive purpose, cut it or redesign it. If a building only produces
resources with no defensive property, redesign it. Every building must
answer both: "What does it make?" and "How does it fight?"

### Anti-Pillars (What This Game Is NOT)

- **NOT a tower defense**: Players are not placing towers. Defense is a
  *consequence* of economic design, never the primary design goal. If a
  feature requires the player to think "where should I put my defenses," it
  violates this principle. They should be thinking "where should I put my
  *refinery*."
- **NOT a base-builder**: No walls, no military units, no base assault mode.
  The installation is automated. The player is an operator, not a general.
- **NOT an idle game**: Attention is always required. Economic decisions have
  real consequences. This is not a game you minimize.

---

## Inspiration and References

| Reference | What We Take From It | What We Do Differently | Why It Matters |
| ---- | ---- | ---- | ---- |
| **Into the Breach** | Readable, legible threat display; every action has visible consequences; small scope, high depth | Our "defense phase" is lighter — 2-3 decisions vs. full tactical puzzle | Proves small-scope strategy games can be critically acclaimed |
| **Mindustry** | Production chains that flow into defense; factory-as-fortress concept | No dedicated turrets — every building fights; roguelite structure replaces open-ended progression | Validates the economy/defense hybrid audience |
| **Slay the Spire** | Roguelite run variety; build-order theory emerges from limited options; boss encounters reward specific counter-builds | No deck; buildings on a spatial grid; economy phase replaces card draw | Proves roguelite strategy with mastery ceiling retains players for 100+ hours |

**Non-game inspirations**: Deep-space mining aesthetics (The Expanse, Alien),
automated manufacturing systems, the visual language of circuit boards and
PCB layouts for the building grid aesthetic.

---

## Target Player Profile

| Attribute | Detail |
| ---- | ---- |
| **Age range** | 18-40 |
| **Gaming experience** | Mid-core to hardcore |
| **Time availability** | 30-60 minute sessions; full run in one sitting |
| **Platform preference** | PC (Steam) |
| **Current games they play** | Slay the Spire, Into the Breach, Factorio (lite), Mindustry |
| **What they're looking for** | A strategy game where mastery feels genuinely earned; roguelite variety that rewards learning over luck |
| **What would turn them away** | Pay-to-win, punishing failure screens, opaque systems with no feedback, mandatory online |

---

## Technical Considerations

| Consideration | Assessment |
| ---- | ---- |
| **Recommended Engine** | **Godot 4** — solo dev, 2D, PC target, weeks timeline. GDScript enables fast iteration. No licensing cost. Strong 2D rendering pipeline handles glow/particle aesthetics well. |
| **Key Technical Challenges** | Simulating resource flow rates efficiently at scale; wave pathfinding against a dynamic building grid; roguelite run state serialization |
| **Art Style** | Abstract sci-fi: geometric shapes, energy glow effects, particle resource flows. No hand-drawn art required. |
| **Art Pipeline Complexity** | Low — procedural/shader-based aesthetics, minimal sprite work |
| **Audio Needs** | Moderate — satisfying production sounds (hums, clicks, flows), wave impact sounds, boss themes |
| **Networking** | None (single-player only for MVP) |
| **Content Volume** | MVP: 6 building types, 5 waves + 1 boss, 1 map layout. Full: 12-15 buildings, 3 boss types, 4-5 map layouts. |
| **Procedural Systems** | Roguelite: random map layouts, randomized building availability per run |

---

## Risks and Open Questions

### Design Risks
- **Core seam risk**: The economic phase and wave phase could feel like two
  separate games if the dual-purpose building mechanic isn't communicated clearly.
  The player must feel their economic decisions *causing* their defensive
  outcomes — not watching an unrelated simulation play out.
- **Difficulty tuning risk**: Wave difficulty must make the player feel clever
  when they survive, not cheated when they fail. Opaque failure = frustration,
  not engagement.
- **Depth vs. legibility tension**: Adding more building types increases depth
  but risks overwhelming legibility. Each new building must pass the "can a new
  player understand this in 5 seconds?" test.

### Technical Risks
- **Resource flow simulation performance**: Simulating flow rates across many
  nodes simultaneously may require optimization passes. Profile early.
- **Wave pathfinding**: Enemies navigating a dynamic grid of production buildings
  requires robust pathfinding (A* with dynamic obstacle updates). Not trivial.

### Market Risks
- **Niche audience**: The "economy IS defense" hook is genuinely novel but may
  require more player education than a conventional tower defense.
- **Comparable title saturation**: Mindustry is free. Into the Breach has strong
  brand recognition. Differentiation must be clear on the store page.

### Scope Risks
- **Building type expansion**: It is very tempting to add "just one more" building
  type. Anti-pillar discipline (Dual-Purpose Everything) is the guard against this.
- **First game complexity**: This concept has more moving parts than a typical
  first game. The MVP scope tier must be strictly enforced.

### Open Questions
- **Is the wave resolution satisfying with only 2-3 choices?** Prototype this
  first. If it feels anticlimactic, the wave phase may need more interactivity.
- **Does the dual-purpose mechanic read clearly to new players?** The first
  playtest should focus on: "Did they understand that their buildings were fighting?"
- **What is the right economy phase duration?** 3 minutes is a hypothesis.
  Playtest with 1.5 min, 3 min, and 5 min variants.

---

## MVP Definition

**Core hypothesis**: Players find it satisfying that their production buildings
are also their defense — and want to optimize their economic layout specifically
to create better defensive configurations.

**Required for MVP**:
1. Grid-based building placement with 5-6 dual-purpose building types
2. Visible resource flow rates between nodes
3. Wave resolution with 2-3 light player decisions
4. One boss encounter (wave 5) with a previewed attack pattern
5. Clear post-wave damage report showing which buildings defended and how

**Explicitly NOT in MVP** (defer to later):
- Roguelite run variety (fixed map layout for MVP)
- Multiple boss types
- Building unlock progression
- Sound design beyond placeholder
- Any UI polish

### Scope Tiers

| Tier | Content | Features | Timeline |
| ---- | ---- | ---- | ---- |
| **MVP** | 1 fixed map, 6 buildings, 5 waves + 1 boss | Dual-purpose placement, resource flows, light wave interaction | 2-3 weeks |
| **Vertical Slice** | 2 map layouts, 8 buildings, 10 waves + 2 bosses | + Roguelite map randomization, boss variety | 4-6 weeks |
| **Alpha** | 4 map layouts, 12 buildings, all boss types | + Full roguelite variety, unlock progression | 2-3 months |
| **Full Vision** | Complete content, polished | All features, audio, leaderboards, full art pass | 4-6 months |

---

## Next Steps

- [ ] Get concept approval from creative-director
- [ ] Fill in CLAUDE.md technology stack based on engine choice (`/setup-engine godot 4.6`)
- [ ] Validate concept doc completeness (`/design-review design/gdd/game-concept.md`)
- [ ] Decompose concept into systems (`/map-systems` — maps dependencies, assigns priorities, guides per-system GDD writing)
- [ ] Create first architecture decision record (`/architecture-decision`)
- [ ] Prototype core loop — specifically the wave resolution moment (`/prototype wave-resolution`)
- [ ] Validate core loop with playtest (`/playtest-report`)
- [ ] Plan first milestone (`/sprint-plan new`)
