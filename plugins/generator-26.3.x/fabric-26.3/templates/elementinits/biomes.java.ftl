<#--
 # This file is part of Fabric-Generator-MCreator.
 # Copyright (C) 2012-2020, Pylo
 # Copyright (C) 2020-2026, Pylo, opensource contributors
 # Copyright (C) 2020-2026, Goldorion, opensource contributors
 #
 # Fabric-Generator-MCreator is free software: you can redistribute it and/or modify
 # it under the terms of the GNU General Public License as published by
 # the Free Software Foundation, either version 3 of the License, or
 # (at your option) any later version.
 #
 # Fabric-Generator-MCreator is distributed in the hope that it will be useful,
 # but WITHOUT ANY WARRANTY; without even the implied warranty of
 # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 # GNU General Public License for more details.
 #
 # You should have received a copy of the GNU General Public License
 # along with Fabric-Generator-MCreator. If not, see <https://www.gnu.org/licenses/>.
-->

<#-- @formatter:off -->
<#include "../mcitems.ftl">

/*
 *    MCreator note: This file will be REGENERATED on each build.
 */

package ${package}.init;

import com.mojang.datafixers.util.Pair;

import net.minecraft.world.level.levelgen.material.MaterialRules;
import net.minecraft.world.level.levelgen.material.rule.MaterialRule;
import net.minecraft.world.level.levelgen.material.rule.SequenceRule;
import net.minecraft.world.level.levelgen.VerticalAnchor;
import net.minecraft.world.level.levelgen.placement.CaveSurface;
import net.minecraft.world.level.dimension.DimensionType;
import net.minecraft.world.level.dimension.BuiltinDimensionTypes;
import net.minecraft.world.level.dimension.LevelStem;
import net.minecraft.world.level.levelgen.NoiseBasedChunkGenerator;
import net.minecraft.world.level.biome.Biome;
import net.minecraft.world.level.biome.Climate;
import net.minecraft.world.level.block.state.BlockState;
import net.minecraft.core.Holder;
import net.minecraft.core.HolderGetter;
import net.minecraft.core.Registry;
import net.minecraft.core.registries.Registries;
import net.minecraft.resources.ResourceKey;
import net.minecraft.resources.Identifier;
import net.fabricmc.fabric.api.event.lifecycle.v1.ServerLifecycleEvents;

import java.util.List;
import java.util.ArrayList;
import java.util.function.Function;

<#assign spawn_overworld = biomes?filter(biome -> biome.spawnBiome)>
<#assign spawn_overworld_caves = biomes?filter(biome -> biome.spawnInCaves)>
<#assign spawn_nether = biomes?filter(biome -> biome.spawnBiomeNether)>

public class ${JavaModName}Biomes {

        public static final Identifier OVERWORLD_BIOMESOURCE_PRESET_ID = Identifier.withDefaultNamespace("overworld");
        public static final Identifier NETHER_BIOMESOURCE_PRESET_ID = Identifier.withDefaultNamespace("nether");

        private static boolean BOOTSTRAP_VALIDATION_PASSED = false;

        private static HolderGetter<Biome> BIOME_GETTER;

        public static void load() {
                <#-- At FMLCommonSetupEvent, bootstrap validation is already done -->
                BOOTSTRAP_VALIDATION_PASSED = true;

                ServerLifecycleEvents.SERVER_STARTING.register((server) -> {
            BIOME_GETTER = server.registryAccess().lookupOrThrow(Registries.BIOME);
            Registry<LevelStem> levelStemTypeRegistry = server.registryAccess().lookupOrThrow(Registries.LEVEL_STEM);
            for (LevelStem levelStem : levelStemTypeRegistry.stream().toList()) {
                Holder<DimensionType> dimensionType = levelStem.type();
                if (dimensionType.is(BuiltinDimensionTypes.NETHER) || dimensionType.is(BuiltinDimensionTypes.OVERWORLD)) {
                    if(levelStem.generator() instanceof NoiseBasedChunkGenerator noiseGenerator) {
                        ((${JavaModName}NoiseGeneratorSettings)(Object)noiseGenerator.generatorSettings().value()).set${modid}DimensionTypeReference(dimensionType);
                    }
                }
            }
                });
        }

        public static Holder<MaterialRule> adaptMaterialRule(Holder<MaterialRule> currentRule, Holder<DimensionType> dimensionType) {
                <#if spawn_overworld?has_content || spawn_overworld_caves?has_content>
                if (dimensionType.is(BuiltinDimensionTypes.OVERWORLD)) return Holder.direct(injectOverworldMaterialRules(currentRule.value()));
                </#if>

                <#if spawn_nether?has_content>
                if (dimensionType.is(BuiltinDimensionTypes.NETHER)) return Holder.direct(injectNetherMaterialRules(currentRule.value()));
                </#if>

                return currentRule;
        }

        public static <T> Climate.ParameterList<T> adaptPresetParameterList(Identifier idArg, Climate.ParameterList<T> originalList, Function<ResourceKey<Biome>, T> lookup) {
                <#-- Skip adaptation during server bootstrap validation, as custom biomes are not available yet -->
                if (!BOOTSTRAP_VALIDATION_PASSED) return originalList;

                <#if spawn_overworld?has_content || spawn_overworld_caves?has_content>
                if (idArg.equals(OVERWORLD_BIOMESOURCE_PRESET_ID)) return ${JavaModName}Biomes.modifyOverworldParameterPoints(originalList, lookup);
                </#if>

                <#if spawn_nether?has_content>
                if (idArg.equals(NETHER_BIOMESOURCE_PRESET_ID)) return ${JavaModName}Biomes.modifyNetherParameterPoints(originalList, lookup);
                </#if>

                return originalList;
        }

        <#if spawn_overworld?has_content || spawn_overworld_caves?has_content>
        private static MaterialRule injectOverworldMaterialRules(MaterialRule currentRule) {
                List<MaterialRule> customMaterialRules = new ArrayList<>();

                <#list spawn_overworld_caves as biome>
                customMaterialRules.add(anyMaterialRule(
                        ResourceKey.create(Registries.BIOME, Identifier.fromNamespaceAndPath("${modid}", "${biome.getModElement().getRegistryName()}")),
                        ${mappedBlockToBlockStateCode(biome.groundBlock)},
                        ${mappedBlockToBlockStateCode(biome.undergroundBlock)},
                        ${mappedBlockToBlockStateCode(biome.getUnderwaterBlock())}
                ));
                </#list>

                <#list spawn_overworld as biome>
                customMaterialRules.add(preliminaryMaterialRule(
                        ResourceKey.create(Registries.BIOME, Identifier.fromNamespaceAndPath("${modid}", "${biome.getModElement().getRegistryName()}")),
                        ${mappedBlockToBlockStateCode(biome.groundBlock)},
                        ${mappedBlockToBlockStateCode(biome.undergroundBlock)},
                        ${mappedBlockToBlockStateCode(biome.getUnderwaterBlock())}
                ));
                </#list>

                if (currentRule instanceof SequenceRule sequenceRule) {
                        customMaterialRules.addAll(sequenceRule.sequence());
                        return MaterialRules.sequence(customMaterialRules.toArray(MaterialRule[]::new));
                } else {
                        customMaterialRules.add(currentRule);
                        return MaterialRules.sequence(customMaterialRules.toArray(MaterialRule[]::new));
                }
        }

        public static <T> Climate.ParameterList<T> modifyOverworldParameterPoints(Climate.ParameterList<T> originalList, Function<ResourceKey<Biome>, T> lookup) {
                List<Pair<Climate.ParameterPoint, T>> parameters = new ArrayList<>(originalList.values());

                <#list spawn_overworld as biome>
                parameters.add(new Pair<>(
                        new Climate.ParameterPoint(
                                Climate.Parameter.span(${biome.genTemperature.min}f, ${biome.genTemperature.max}f),
                                Climate.Parameter.span(${biome.genHumidity.min}f, ${biome.genHumidity.max}f),
                                Climate.Parameter.span(${biome.genContinentalness.min}f, ${biome.genContinentalness.max}f),
                                Climate.Parameter.span(${biome.genErosion.min}f, ${biome.genErosion.max}f),
                                Climate.Parameter.point(0.0f),
                                Climate.Parameter.span(${biome.genWeirdness.min}f, ${biome.genWeirdness.max}f),
                                0 <#-- offset -->
                        ),
                        lookup.apply(ResourceKey.create(Registries.BIOME, Identifier.fromNamespaceAndPath("${modid}", "${biome.getModElement().getRegistryName()}")))
                ));
                parameters.add(new Pair<>(
                        new Climate.ParameterPoint(
                                Climate.Parameter.span(${biome.genTemperature.min}f, ${biome.genTemperature.max}f),
                                Climate.Parameter.span(${biome.genHumidity.min}f, ${biome.genHumidity.max}f),
                                Climate.Parameter.span(${biome.genContinentalness.min}f, ${biome.genContinentalness.max}f),
                                Climate.Parameter.span(${biome.genErosion.min}f, ${biome.genErosion.max}f),
                                Climate.Parameter.point(1.0f),
                                Climate.Parameter.span(${biome.genWeirdness.min}f, ${biome.genWeirdness.max}f),
                                0 <#-- offset -->
                        ),
                        lookup.apply(ResourceKey.create(Registries.BIOME, Identifier.fromNamespaceAndPath("${modid}", "${biome.getModElement().getRegistryName()}")))
                ));
                </#list>

                <#list spawn_overworld_caves as biome>
                parameters.add(new Pair<>(
                        new Climate.ParameterPoint(
                                Climate.Parameter.span(${biome.genTemperature.min}f, ${biome.genTemperature.max}f),
                                Climate.Parameter.span(${biome.genHumidity.min}f, ${biome.genHumidity.max}f),
                                Climate.Parameter.span(${biome.genContinentalness.min}f, ${biome.genContinentalness.max}f),
                                Climate.Parameter.span(${biome.genErosion.min}f, ${biome.genErosion.max}f),
                                Climate.Parameter.span(${biome.genDepth.min}f, ${biome.genDepth.max}f),
                                Climate.Parameter.span(${biome.genWeirdness.min}f, ${biome.genWeirdness.max}f),
                                0 <#-- offset -->
                        ),
                        lookup.apply(ResourceKey.create(Registries.BIOME, Identifier.fromNamespaceAndPath("${modid}", "${biome.getModElement().getRegistryName()}")))
                ));
                </#list>

                return new Climate.ParameterList<>(parameters);
        }
        </#if>

        <#if spawn_nether?has_content>
        private static MaterialRule injectNetherMaterialRules(MaterialRule currentRule) {
                List<MaterialRule> customMaterialRules = new ArrayList<>();

                <#list spawn_nether as biome>
                customMaterialRules.add(anyMaterialRule(
                        ResourceKey.create(Registries.BIOME, Identifier.fromNamespaceAndPath("${modid}", "${biome.getModElement().getRegistryName()}")),
                        ${mappedBlockToBlockStateCode(biome.groundBlock)},
                        ${mappedBlockToBlockStateCode(biome.undergroundBlock)},
                        ${mappedBlockToBlockStateCode(biome.getUnderwaterBlock())}
                ));
                </#list>

                if (currentRule instanceof SequenceRule sequenceRule) {
                        customMaterialRules.addAll(sequenceRule.sequence());
                        return MaterialRules.sequence(customMaterialRules.toArray(MaterialRule[]::new));
                } else {
                        customMaterialRules.add(currentRule);
                        return MaterialRules.sequence(customMaterialRules.toArray(MaterialRule[]::new));
                }
        }

        public static <T> Climate.ParameterList<T> modifyNetherParameterPoints(Climate.ParameterList<T> originalList, Function<ResourceKey<Biome>, T> lookup) {
                List<Pair<Climate.ParameterPoint, T>> parameters = new ArrayList<>(originalList.values());

                <#list spawn_nether as biome>
                parameters.add(new Pair<>(
                        new Climate.ParameterPoint(
                                Climate.Parameter.span(${biome.genTemperature.min}f, ${biome.genTemperature.max}f),
                                Climate.Parameter.span(${biome.genHumidity.min}f, ${biome.genHumidity.max}f),
                                Climate.Parameter.span(${biome.genContinentalness.min}f, ${biome.genContinentalness.max}f),
                                Climate.Parameter.span(${biome.genErosion.min}f, ${biome.genErosion.max}f),
                                Climate.Parameter.point(0.0f),
                                Climate.Parameter.span(${biome.genWeirdness.min}f, ${biome.genWeirdness.max}f),
                                0 <#-- offset -->
                        ),
                        lookup.apply(ResourceKey.create(Registries.BIOME, Identifier.fromNamespaceAndPath("${modid}", "${biome.getModElement().getRegistryName()}")))
                ));
                parameters.add(new Pair<>(
                        new Climate.ParameterPoint(
                                Climate.Parameter.span(${biome.genTemperature.min}f, ${biome.genTemperature.max}f),
                                Climate.Parameter.span(${biome.genHumidity.min}f, ${biome.genHumidity.max}f),
                                Climate.Parameter.span(${biome.genContinentalness.min}f, ${biome.genContinentalness.max}f),
                                Climate.Parameter.span(${biome.genErosion.min}f, ${biome.genErosion.max}f),
                                Climate.Parameter.point(1.0f),
                                Climate.Parameter.span(${biome.genWeirdness.min}f, ${biome.genWeirdness.max}f),
                                0 <#-- offset -->
                        ),
                        lookup.apply(ResourceKey.create(Registries.BIOME, Identifier.fromNamespaceAndPath("${modid}", "${biome.getModElement().getRegistryName()}")))
                ));
                </#list>

                return new Climate.ParameterList<>(parameters);
        }
        </#if>

        <#if spawn_overworld?has_content>
        private static MaterialRule preliminaryMaterialRule(ResourceKey<Biome> biomeKey, BlockState groundBlock, BlockState undergroundBlock, BlockState underwaterBlock) {
                return MaterialRules.ifTrue(MaterialRules.isBiome(BIOME_GETTER, biomeKey),
                        MaterialRules.ifTrue(MaterialRules.abovePreliminarySurface(),
                                MaterialRules.sequence(
                                        MaterialRules.ifTrue(MaterialRules.stoneDepthCheck(0, false, 0, CaveSurface.FLOOR),
                                                MaterialRules.sequence(
                                                        MaterialRules.ifTrue(MaterialRules.waterBlockCheck(-1, 0),
                                                                MaterialRules.state(groundBlock)
                                                        ),
                                                        MaterialRules.state(underwaterBlock)
                                                )
                                        ),
                                        MaterialRules.ifTrue(MaterialRules.stoneDepthCheck(0, true, 0, CaveSurface.FLOOR),
                                                MaterialRules.state(undergroundBlock)
                                        )
                                )
                        )
                );
        }
        </#if>

        <#if spawn_nether?has_content || spawn_overworld_caves?has_content>
        private static MaterialRule anyMaterialRule(ResourceKey<Biome> biomeKey, BlockState groundBlock, BlockState undergroundBlock, BlockState underwaterBlock) {
                return MaterialRules.ifTrue(MaterialRules.isBiome(BIOME_GETTER, biomeKey),
                        MaterialRules.ifTrue(MaterialRules.yBlockCheck(VerticalAnchor.aboveBottom(5), 0),
                                MaterialRules.ifTrue(MaterialRules.not(MaterialRules.yBlockCheck(VerticalAnchor.belowTop(5), 0)),
                                        MaterialRules.sequence(
                                                MaterialRules.ifTrue(MaterialRules.stoneDepthCheck(0, false, 0, CaveSurface.FLOOR),
                                                        MaterialRules.sequence(
                                                                MaterialRules.ifTrue(MaterialRules.waterBlockCheck(-1, 0),
                                                                        MaterialRules.state(groundBlock)
                                                                ),
                                                                MaterialRules.state(underwaterBlock)
                                                        )
                                                ),
                                                MaterialRules.ifTrue(MaterialRules.stoneDepthCheck(0, true, 0, CaveSurface.FLOOR),
                                                        MaterialRules.state(undergroundBlock)
                                                )
                                        )
                                )
                        )
                );
        }
        </#if>

        public interface ${JavaModName}NoiseGeneratorSettings {
                void set${modid}DimensionTypeReference(Holder<DimensionType> dimensionType);
        }

}

<#-- @formatter:on -->
