<#--
 # This file is part of Fabric-Generator-MCreator.
 # Copyright (C) 2012-2020, Pylo
 # Copyright (C) 2020-2025, Pylo, opensource contributors
 # Copyright (C) 2020-2026, Goldorion, opensource contributors
-->

<#-- @formatter:off -->

/*
 *	MCreator note: This file will be REGENERATED on each build.
 */

package ${package}.init;

import net.fabricmc.fabric.api.biome.v1.BiomeModifications;
import net.fabricmc.fabric.api.biome.v1.BiomeSelectionContext;
import net.minecraft.core.registries.Registries;
import net.minecraft.world.level.levelgen.feature.configurations.OreConfiguration;
import net.minecraft.resources.ResourceKey;
import net.minecraft.resources.Identifier;
import net.minecraft.world.level.levelgen.GenerationStep;

import java.util.function.Predicate;

public class ${JavaModName}Features {

	public static void load() {
        <#list features as feature>
            <#if feature.getModElement().getTypeString() == "feature">
                <#if feature.hasPlacedFeature()>
		register("${feature.getModElement().getRegistryName()}",
			${feature.getModElement().getName()}Feature.GENERATE_BIOMES, GenerationStep.Decoration.${generator.map(feature.generationStep, "generationsteps")?upper_case});
                </#if>
            <#elseif feature.getModElement().getTypeString() == "block">
		register("${feature.getModElement().getRegistryName()}",
			${feature.getModElement().getName()}Block.GENERATE_BIOMES, GenerationStep.Decoration.UNDERGROUND_ORES);
            <#elseif feature.getModElement().getTypeString() == "plant">
		register("${feature.getModElement().getRegistryName()}",
			${feature.getModElement().getName()}Block.GENERATE_BIOMES, GenerationStep.Decoration.VEGETAL_DECORATION);
            </#if>
        </#list>
	}

	private static void register(String registryname, Predicate<BiomeSelectionContext> biomes, GenerationStep.Decoration stage) {
	 	BiomeModifications.addFeature(biomes, stage, ResourceKey.create(Registries.PLACED_FEATURE, Identifier.fromNamespaceAndPath(${JavaModName}.MODID, registryname)));
	}
}
<#-- @formatter:on -->
