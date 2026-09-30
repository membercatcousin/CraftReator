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

import java.util.function.Predicate;

<@javacompress>
public class ${name}Feature {

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

}</@javacompress>
<#-- @formatter:on -->
