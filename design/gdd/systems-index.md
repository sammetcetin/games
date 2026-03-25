# Systems Index: Extraction Protocol

> **Status**: Draft
> **Created**: 2026-03-26
> **Last Updated**: 2026-03-26
> **Source Concept**: design/gdd/game-concept.md

---

## Overview

Extraction Protocol is a resource-management roguelite where every production
building is simultaneously a defensive structure. The mechanical scope divides
into four pillars: an **economy layer** (resource databases, flow simulation,
building placement on a tile grid), a **combat layer** (enemy pathfinding through
a dynamic grid, wave spawning, boss encounters), a **meta layer** (roguelite run
state, cross-run progression, procedural map generation), and a **presentation
layer** (HUDs and UIs that surface the underlying simulation readably — Pillar 1:
Readable Systems). The game has no dedicated defense structures; the seam between
economy and combat is the design's core innovation and its highest-risk element.
MVP focuses on proving that seam is satisfying before adding roguelite variety.

---

## Systems Enumeration

| # | System Name | Category | Priority | Status | Design Doc | Depends On |
|---|-------------|----------|----------|--------|------------|------------|
| 1 | Game State Machine | Core | MVP | Not Started | — | — |
| 2 | Resource Database | Economy | MVP | Not Started | — | — |
| 3 | Building Database | Economy | MVP | Not Started | — | — |
| 4 | Grid/Map | Core | MVP | Not Started | — | — |
| 5 | Building Placement | Gameplay | MVP | Not Started | — | Grid/Map, Building Database |
| 6 | Resource Flow | Economy | MVP | Not Started | — | Resource Database, Building Database |
| 7 | Enemy System | Gameplay | MVP | Not Started | — | — |
| 8 | Wave Spawner | Gameplay | MVP | Not Started | — | Enemy System, Game State Machine |
| 9 | Enemy Pathfinding *(inferred)* | Gameplay | MVP | Not Started | — | Grid/Map, Enemy System |
| 10 | Active Ability System *(inferred)* | Gameplay | MVP | Not Started | — | Building Database, Game State Machine |
| 11 | Wave Resolution | Gameplay | MVP | Not Started | — | Wave Spawner, Enemy Pathfinding, Active Ability System, Game State Machine |
| 12 | Boss Preview *(inferred)* | Gameplay | MVP | Not Started | — | Building Database, Game State Machine |
| 13 | Boss Encounter | Gameplay | MVP | Not Started | — | Wave Resolution, Boss Preview |
| 14 | Post-Wave Damage Report | Gameplay | MVP | Not Started | — | Wave Resolution |
| 15 | Run State *(inferred)* | Progression | MVP | Not Started | — | Game State Machine, Building Placement, Resource Flow |
| 16 | Build Phase HUD | UI | MVP | Not Started | — | Building Placement, Resource Flow |
| 17 | Wave Phase UI | UI | MVP | Not Started | — | Wave Resolution, Active Ability System |
| 18 | Damage Report UI | UI | MVP | Not Started | — | Post-Wave Damage Report |
| 19 | Boss Preview UI | UI | MVP | Not Started | — | Boss Preview |
| 20 | Run End / Game Over UI | UI | MVP | Not Started | — | Run State |
| 21 | Main Menu / Run Start UI | UI | MVP | Not Started | — | — |
| 22 | Map Generation *(inferred)* | Core | Vertical Slice | Not Started | — | Grid/Map |
| 23 | Building Upgrade *(inferred)* | Gameplay | Vertical Slice | Not Started | — | Building Placement, Building Database |
| 24 | Meta-Progression *(inferred)* | Progression | Vertical Slice | Not Started | — | Run State |
| 25 | Save/Load *(inferred)* | Persistence | Vertical Slice | Not Started | — | Meta-Progression |
| 26 | Score / Stats *(inferred)* | Meta | Alpha | Not Started | — | Run State |

---

## Categories

| Category | Description | Systems in This Game |
|----------|-------------|----------------------|
| **Core** | Foundation systems everything depends on | Game State Machine, Grid/Map, Map Generation |
| **Gameplay** | Systems that make the game fun | Building Placement, Resource Flow, Enemy System, Wave Spawner, Enemy Pathfinding, Active Ability System, Wave Resolution, Boss Preview, Boss Encounter, Post-Wave Damage Report, Building Upgrade |
| **Economy** | Resource creation and consumption | Resource Database, Building Database, Resource Flow |
| **Progression** | How the player grows over time | Run State, Meta-Progression |
| **Persistence** | Save state and continuity | Save/Load |
| **UI** | Player-facing information displays | Build Phase HUD, Wave Phase UI, Damage Report UI, Boss Preview UI, Run End / Game Over UI, Main Menu / Run Start UI |
| **Meta** | Systems outside the core game loop | Score / Stats |

---

## Priority Tiers

| Tier | Definition | Target Milestone | Design Urgency |
|------|------------|------------------|----------------|
| **MVP** | Required for the core loop to function. Without these, you can't test "is this fun?" | First playable prototype (2-3 weeks) | Design FIRST |
| **Vertical Slice** | Required for roguelite variety and a complete, replayable experience. | Vertical Slice / demo (4-6 weeks) | Design SECOND |
| **Alpha** | All features present in rough form. Complete mechanical scope. | Alpha milestone (2-3 months) | Design THIRD |
| **Full Vision** | Polish, edge cases, and content-complete features. | Beta / Release (4-6 months) | Design as needed |

---

## Dependency Map

### Foundation Layer (no dependencies)

1. **Game State Machine** — The phase arbiter. Every system queries current state (Build / Wave / Post-Wave / Boss / Run End). No deps; must exist before anything time-sensitive.
2. **Resource Database** — Defines all resource types and their properties. Nothing can flow until resources are named.
3. **Building Database** — Defines the 6 building types: economic output rates + defensive properties. The central design contract for the game.
4. **Grid/Map** — The asteroid tile grid. All spatial operations (placement, pathfinding, spawn points) go through this.

### Core Layer (depends on Foundation)

1. **Building Placement** — depends on: Grid/Map, Building Database
2. **Resource Flow** — depends on: Resource Database, Building Database
3. **Enemy System** — depends on: (standalone — enemy type data, health, movement stats)
4. **Wave Spawner** — depends on: Enemy System, Game State Machine

### Feature Layer (depends on Core)

1. **Enemy Pathfinding** — depends on: Grid/Map, Enemy System
2. **Active Ability System** — depends on: Building Database, Game State Machine
3. **Wave Resolution** — depends on: Wave Spawner, Enemy Pathfinding, Active Ability System, Game State Machine
4. **Boss Preview** — depends on: Building Database, Game State Machine
5. **Boss Encounter** — depends on: Wave Resolution, Boss Preview
6. **Post-Wave Damage Report** — depends on: Wave Resolution
7. **Run State** — depends on: Game State Machine, Building Placement, Resource Flow
8. **Map Generation** *(V-Slice)* — depends on: Grid/Map
9. **Building Upgrade** *(V-Slice)* — depends on: Building Placement, Building Database
10. **Meta-Progression** *(V-Slice)* — depends on: Run State

### Presentation Layer (depends on Features)

1. **Build Phase HUD** — depends on: Building Placement, Resource Flow
2. **Wave Phase UI** — depends on: Wave Resolution, Active Ability System
3. **Damage Report UI** — depends on: Post-Wave Damage Report
4. **Boss Preview UI** — depends on: Boss Preview
5. **Run End / Game Over UI** — depends on: Run State, Meta-Progression
6. **Main Menu / Run Start UI** — depends on: Meta-Progression (for unlock display in V-Slice; standalone in MVP)

### Polish Layer

1. **Save/Load** — depends on: Meta-Progression
2. **Score / Stats** — depends on: Run State

---

## Recommended Design Order

| Order | System | Priority | Layer | Agent(s) | Est. Effort |
|-------|--------|----------|-------|----------|-------------|
| 1 | Game State Machine | MVP | Foundation | game-designer, lead-programmer | S |
| 2 | Resource Database | MVP | Foundation | game-designer, systems-designer | S |
| 3 | Building Database | MVP | Foundation | game-designer, systems-designer | M |
| 4 | Grid/Map | MVP | Foundation | game-designer, engine-programmer | S |
| 5 | Building Placement | MVP | Core | game-designer, gameplay-programmer | M |
| 6 | Resource Flow | MVP | Core | systems-designer, gameplay-programmer | M |
| 7 | Enemy System | MVP | Core | game-designer, systems-designer | S |
| 8 | Wave Spawner | MVP | Core | game-designer, systems-designer | S |
| 9 | Enemy Pathfinding | MVP | Feature | engine-programmer | M |
| 10 | Active Ability System | MVP | Feature | game-designer, systems-designer | M |
| 11 | Wave Resolution | MVP | Feature | game-designer, systems-designer | M |
| 12 | Boss Preview | MVP | Feature | game-designer | S |
| 13 | Boss Encounter | MVP | Feature | game-designer, systems-designer | M |
| 14 | Post-Wave Damage Report | MVP | Feature | game-designer | S |
| 15 | Run State | MVP | Feature | lead-programmer | S |
| 16 | Build Phase HUD | MVP | UI | ui-programmer, ux-designer | M |
| 17 | Wave Phase UI | MVP | UI | ui-programmer, ux-designer | S |
| 18 | Damage Report UI | MVP | UI | ui-programmer | S |
| 19 | Boss Preview UI | MVP | UI | ui-programmer | S |
| 20 | Run End / Game Over UI | MVP | UI | ui-programmer | S |
| 21 | Main Menu / Run Start UI | MVP | UI | ui-programmer | S |
| 22 | Map Generation | Vertical Slice | Feature | engine-programmer | M |
| 23 | Building Upgrade | Vertical Slice | Feature | game-designer, systems-designer | M |
| 24 | Meta-Progression | Vertical Slice | Feature | game-designer, systems-designer | M |
| 25 | Save/Load | Vertical Slice | Persistence | lead-programmer | S |
| 26 | Score / Stats | Alpha | Meta | game-designer | S |

*Effort: S = 1 session, M = 2-3 sessions, L = 4+ sessions.*
*Note: Foundation systems (#1-4) can be designed in parallel. Same for Core (#5-8).*

---

## Circular Dependencies

- **None found.** The dependency graph is a clean DAG (directed acyclic graph).

---

## High-Risk Systems

| System | Risk Type | Risk Description | Mitigation |
|--------|-----------|-----------------|------------|
| **Wave Resolution** | Design | The core open question: is the wave payoff satisfying with only 2-3 player choices? If not, the entire game concept fails. | **Prototype first** — before designing any other system, run `/prototype wave-resolution` to validate this assumption. |
| **Building Database** | Design | The dual-purpose mechanic lives here. Each building must be both economically meaningful AND defensively interesting. Getting this wrong affects all 26 systems. | Design this with the systems-designer agent. Define all 6 buildings completely before any other system references them. |
| **Enemy Pathfinding** | Technical | A* with dynamic obstacle updates (buildings change mid-run) is non-trivial. Performance risk at scale. | Prototype pathfinding on the grid early. Profile before scaling to large grids. |
| **Resource Flow** | Technical | Simulating flow rates across many nodes simultaneously may have performance cliffs. | Profile early. Consider a tick-based (not continuous) simulation to control update cost. |
| **Game State Machine** | Scope | Poorly designed state machines become spaghetti. Every system touches this. | Design with a clean extensible API. Use an architecture-decision to pin the pattern before coding. |

---

## Progress Tracker

| Metric | Count |
|--------|-------|
| Total systems identified | 26 |
| Design docs started | 0 |
| Design docs reviewed | 0 |
| Design docs approved | 0 |
| MVP systems designed | 0 / 21 |
| Vertical Slice systems designed | 0 / 4 |

---

## Next Steps

- [ ] Design MVP Foundation systems first — start with `/design-system building-database` (highest-risk Foundation system)
- [ ] Run `/prototype wave-resolution` early — validate the core open question before investing in full GDD authoring
- [ ] Run `/design-review design/gdd/systems-index.md` to validate completeness
- [ ] Run `/design-system [system-name]` for each system in design order
- [ ] Run `/gate-check pre-production` when all MVP systems are designed
