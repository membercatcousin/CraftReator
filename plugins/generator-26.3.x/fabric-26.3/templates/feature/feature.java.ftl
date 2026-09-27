<#--
 # This file is part of Fabric-Generator-MCreator.
 # Copyright (C) 2012-2020, Pylo
 # Copyright (C) 2020-2026, Pylo, opensource contributors
 # Copyright (C) 2020-2026, Goldorion, opensource contributors
-->

<#-- @formatter:off -->
<#include "../procedures.java.ftl">
<#assign biomeSelector = "includeByKey">
<#assign resourceKey = "ResourceKey">
<#if data.restrictionBiomes?has_content>
	<#list w.filterBrokenReferences(data.restrictionBiomes) as restrictionBiome>
		<#if restrictionBiome?contains("#")>
			<#assign biomeSelector = "tag">
			<#assign resourceKey = "TagKey">
			<#break>
		</#if>
	</#list>
</#if>
package ${package}.world.features;

import net.fabricmc.fabric.api.biome.v1.BiomeSelectors;
import net.fabricmc.fabric.api.biome.v1.BiomeSelectionContext;
import net.minecraft.core.registries.Registries;
import net.minecraft.resources.ResourceKey;
import net.minecraft.resources.Identifier;
import net.minecraft.tags.TagKey;
import net.minecraft.world.level.WorldGenLevel;
import net.minecraft.world.level.levelgen.feature.Feature;
import net.minecraft.world.level.levelgen.feature.FeaturePlaceContext;
import net.minecraft.world.level.levelgen.feature.OreFeature;
import net.minecraft.world.level.levelgen.feature.configurations.OreConfiguration;

import java.util.function.Predicate;

<#assign configuration = generator.map(featuretype, "features", 1)>

<@javacompress>
public class ${name}Feature extends ${generator.map(featuretype, "features")} {

	public ${name}Feature() {
		super(java.util.List.of(), 0);
	}

	public static final Predicate<BiomeSelectionContext> GENERATE_BIOMES = BiomeSelectors.
	<#if data.restrictionBiomes?has_content>
	${biomeSelector}(
		<#list w.filterBrokenReferences(data.restrictionBiomes) as restrictionBiome>
			${resourceKey}.create(Registries.BIOME, Identifier.parse("${restrictionBiome?replace("#", "")}"))<#sep>,
		</#list>
	)
	<#else>
	all()
	</#if>;

	<#if hasProcedure(data.generateCondition)>
	@Override public boolean place(FeaturePlaceContext<${configuration}> context) {
		<#-- #4781 - we need to use WorldGenLevel instead of Level, or one can run incompatible procedures in condition -->
		WorldGenLevel world = context.level();
		int x = context.origin().getX();
		int y = context.origin().getY();
		int z = context.origin().getZ();
		if (!<@procedureOBJToConditionCode data.generateCondition/>)
			return false;

		return super.place(context);
	}
	</#if>
}</@javacompress>
<#-- @formatter:on -->
