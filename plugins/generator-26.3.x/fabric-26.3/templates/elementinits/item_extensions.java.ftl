<#--
 # This file is part of Fabric-Generator-MCreator.
 # Copyright (C) 2020-2026, Goldorion, opensource contributors
-->

<#-- @formatter:off -->
<#include "../mcitems.ftl">
<#include "../procedures.java.ftl">

/*
 *	MCreator note: This file will be REGENERATED on each build.
 */

package ${package}.init;

import net.minecraft.core.component.DataComponents;
import net.minecraft.world.item.component.CookingFuel;
import net.minecraft.world.item.component.Compostable;
import net.minecraft.world.level.storage.loot.providers.number.ints.ResolvableInt;
import net.minecraft.world.level.storage.loot.providers.number.floats.ResolvableFloat;
import net.minecraft.world.level.storage.loot.providers.number.floats.ContextFloatProviders;

<@javacompress>
public class ${JavaModName}ItemExtensions {

	public static void load() {
        <#if (itemextensions?filter(e -> e.compostLayerChance gt 0)?size > 0) || (w.getGElementsOfType('itemextension')?filter(e -> e.enableFuel)?size > 0)>
        net.fabricmc.fabric.api.item.v1.DefaultItemComponentEvents.MODIFY.register(modifyContext -> {
            <#list itemextensions?filter(e -> e.compostLayerChance gt 0) as extension>
            modifyContext.modify(${mappedMCItemToItem(extension.item)}, builder -> {
                builder.set(DataComponents.COMPOSTABLE, new Compostable(new ResolvableInt.Constant((int) (${extension.compostLayerChance} * 100))));
            });
            </#list>

            <#list itemextensions?filter(e -> e.enableFuel) as extension>
            modifyContext.modify(${mappedMCItemToItem(extension.item)}, builder -> {
                <#if hasProcedure(extension.fuelSuccessCondition)>if(<@procedureOBJToConditionCode extension.fuelSuccessCondition/>)</#if>
                builder.set(DataComponents.COOKING_FUEL, new CookingFuel(
                    new ResolvableInt.Constant(
                        <#if hasProcedure(extension.fuelPower)>
                            (int) <@procedureOBJToNumberCode extension.fuelPower/>
                        <#else>
                            ${extension.fuelPower.getFixedValue()}
                        </#if>
                    ),
                    ResolvableFloat.fromKey(ContextFloatProviders.COOKING_DEFAULT_SPEED_MULTIPLIER)
                ));
            });
            </#list>
        });
        </#if>
	}
}</@javacompress>
<#-- @formatter:on -->
