# Prototype Report: Wave Resolution

## Hypothesis

Wave resolution will feel satisfying with only 2-3 light player decisions per
wave. Specifically:

1. Passive building defenses firing automatically will make the player feel like
   *their factory* is fighting — not that they are personally fighting.
2. 3 activated abilities (Trigger Pulse / Detonate Refinery / Reinforce Sector)
   will provide enough agency without overwhelming the player.
3. The post-wave damage report will clearly communicate WHICH buildings defended
   and HOW, making the dual-purpose mechanic legible to a new player.

## Approach

Built a minimal Godot 4.6 scene (3 files: ~280 lines GDScript total) with:
- 9×8 tile grid, 4 hardcoded dual-purpose buildings
- 5 enemies: 3 north-lane, 2 east-lane
- Passive defenses fire automatically at wave start (Solar Array EM pulse,
  Ore Processor barrier)
- 3 player-activated ability buttons available during the wave
- Post-wave damage report + playtester prompt

Shortcuts taken (intentional):
- No real pathfinding — enemies are static icons representing incoming threats
- No animations — state changes shown as text log only
- No sound
- No art — pure colored rectangles
- Hardcoded building placement, no grid interaction
- Wave difficulty not tuned — hardcoded enemy HP values
- Single wave only; no run structure

**Timebox**: ~2 hours design + implementation.

## Result

> ⚠️ **Requires playtesting to complete this section.**
> Open in Godot 4.6 (`File → Open Project → prototypes/wave-resolution/`) and
> run the scene. Play through 3-5 times using different ability combinations.
> Answer the 3 playtester questions shown after each wave, then fill in below.

### Feel: Factory vs. Player Agency
*Did it feel like the factory was fighting, or like you personally were fighting?*

[ ] Strongly felt like the factory — passive defenses did most of the work ← (desired)
[ ] Felt like both equally
[ ] Felt like my personal ability use determined the outcome
[ ] Felt disconnected — didn't feel like either

Notes: _______________________________________________

### Ability Count: 3 decisions
*Were 3 activated abilities too few, about right, or too many?*

[ ] Too few — I wanted more decisions
[ ] About right — felt like meaningful choices without micromanagement ← (desired)
[ ] Too many — felt like work, not strategy
[ ] Timing felt off — I wanted to decide EARLIER / LATER (circle one)

Notes: _______________________________________________

### Damage Report Legibility
*Was the post-wave report clear enough to understand what happened and why you won/lost?*

[ ] Very clear — I could reconstruct exactly what happened
[ ] Mostly clear — one thing confused me: _______________
[ ] Unclear — I didn't understand why enemies survived/died
[ ] Too much information — felt noisy

Notes: _______________________________________________

## Metrics

*(Fill in after playtesting)*

- Playtest sessions: ___
- Average ability use per run: ___/3
- Most-used ability: _______________
- Least-used ability: _______________
- Times all enemies neutralized: ___/___
- Reported "factory is fighting" feeling: Y / N / Unsure
- Reported wanting more wave interactivity: Y / N

## Recommendation

*(Fill in after playtesting)*

**[ ] PROCEED** — Wave resolution feels satisfying. 3 decisions is right. Build it properly.

**[ ] PIVOT** — Core direction is right but needs adjustment:
- Increase decisions to ___
- Change passive/active ratio (more passive / more active)
- Replace ability X with: _______________

**[ ] KILL** — Wave resolution does not work. The factory-defense seam is not
satisfying. Fundamental concept revision required.

---

## Pre-Playtesting Design Analysis

Based on the prototype design alone, here are the expected risks before running it:

### Risk 1: Passive-heavy imbalance
The passive defenses (Solar Array auto-pulse, Ore Processor barrier) may do most
of the work, leaving the 3 abilities feeling redundant. **Watch for**: player uses
all 3 abilities but it doesn't change the outcome.

**Proposed fix if this occurs**: Make passive defenses weaker and active abilities
more critical. Or: preview "predicted damage" before wave — player must use
abilities to prevent predicted losses.

### Risk 2: No timing tension
All 3 abilities are available simultaneously from wave start. There's no cost to
using them immediately. **Watch for**: player clicks all 3 in the first 5 seconds
without deliberating.

**Proposed fix if this occurs**: Abilities have a short cooldown between uses, or
are only available at specific wave moments (e.g., when enemy reaches a tile).

### Risk 3: Refinery sacrifice feels unfair
Detonating the Refinery permanently destroys it. Player may feel punished for
using an ability. **Watch for**: player never uses the detonate ability to avoid
losing the building.

**Proposed fix if this occurs**: Refinery rebuilds over the next economy phase
(at cost). Sacrifice is temporary, not permanent.

### Risk 4: Wave feels too static (no movement)
Without real enemy movement/animation, the "wave" may feel like reading a text
log, not surviving an assault. The feel test requires movement to truly answer.

**Proposed fix**: Even simple tween animations of enemy icons moving toward the
grid would significantly improve the feel assessment accuracy. Consider a v2.

## If Proceeding: Production Requirements

1. **Real enemy movement**: Enemies must visibly traverse the grid. A* pathfinding
   with dynamic obstacle updates (see systems-index.md: Enemy Pathfinding, High Risk).
2. **Ability timing system**: Decisions should be made when an enemy enters a
   radius, not front-loaded at wave start. Tension requires timing.
3. **Visual feedback for defensive properties**: Buildings should visibly "activate"
   (glow, particle burst) when their defensive property fires. Core to the
   "factory is fighting" feeling.
4. **Passive/active balance tuning**: Based on playtest data — likely needs 2-3
   iterations of HP/damage values before production design is locked.
5. **Ability cost model**: Prototype uses free abilities. Production needs a
   resource cost (energy, fuel) to make choices meaningful.

## Lessons Learned

- The damage report (which buildings fired, what they did) is architecturally
  load-bearing — it's what teaches the player the dual-purpose system over
  multiple runs. It needs to be a first-class feature, not an afterthought.
- The "Detonate Refinery" (sacrifice building for power) is the most
  design-interesting ability and probably the most revealing playtesting signal.
  If players never use it, the risk/reward framing is broken.
- Static prototype cannot fully validate the "factory is fighting" feeling —
  the sensation requires movement and audio. Plan for a v2 with basic enemy
  movement before committing to the full production design.
