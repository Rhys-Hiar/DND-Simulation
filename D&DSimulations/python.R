,
initial_cost = 0,
size = "Dagger",
effect = "Deals 1-2 damage",
speed = 5,
duration = 0
),
list(
  name = "Ice Scimitar",
  casting_time = 2,
  range = 0,
  initial_cost = 0,
  size = "Scimitar",
  effect = "Equip a magic ice scimitar, deals 1-8 damage if attack hits",
  speed = 0,
  duration = 0
),
list(
  name = "Ice Wall",
  casting_time = 4,
  range = 6,
  initial_cost = 0,
  size = 25,
  effect = "Creates a wall of ice, each 5ft x 5ft square can take 4 points of damage before shattering",
  speed = 2,
  duration = 0
),
list(
  name = "Heal",
  casting_time = 4,
  range = 2,
  initial_cost = 2,
  size = 0,
  effect = "Heal 1-4 damage",
  speed = Inf,
  duration = Inf
)
)
}
# Simulate combat rounds
for (round in 1:10) {  # Simulate 10 rounds of combat
  print(paste("Round", round))
  simulate_combat_round(players)
}
}

# Run the simulation
simulate_combat()
