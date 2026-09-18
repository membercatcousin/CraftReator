"${registryname}_${cbi}": {
  "trigger": "minecraft:location",
  "conditions": {
    "player": [
        {
            "condition": "minecraft:entity_properties",
            "entity": "this",
            "predicate": {
              "minecraft:location": {
                "biomes": "${generator.map(field$biome, "biomes")}"
              }
            }
        }
    ]
  }
},