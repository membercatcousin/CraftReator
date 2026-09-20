<#--
 # This file is part of Fabric-Generator-MCreator.
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
<#include "../procedures.java.ftl">

/*
 *	MCreator note: This file will be REGENERATED on each build.
 */

package ${package}.init;

<@javacompress>
public class ${JavaModName}ItemExtensions {

	public static void load() {
        <#if (itemextensions?filter(e -> e.compostLayerChance gt 0)?size > 0) || (w.getGElementsOfType('itemextension')?filter(e -> e.enableFuel)?size > 0)>
        net.fabricmc.fabric.api.item.v1.DefaultItemComponentEvents.MODIFY.register(modifyContext -> {
            <#list itemextensions?filter(e -> e.compostLayerChance gt 0) as extension>
            modifyContext.modify(${mappedMCItemToItem(extension.item)}, builder -> {
                builder.set(net.minecraft.core.component.DataComponents.COMPOSTABLE, new net.minecraft.world.item.component.Compostable(new net.minecraft.util.valueproviders.ResolvableInt.Constant((int) (${extension.compostLayerChance} * 100))));
            });
            </#list>

            <#list itemextensions?filter(e -> e.enableFuel) as extension>
            modifyContext.modify(${mappedMCItemToItem(extension.item)}, builder -> {
                <#if hasProcedure(extension.fuelSuccessCondition)>if(<@procedureOBJToConditionCode extension.fuelSuccessCondition/>)</#if>
                builder.set(net.minecraft.core.component.DataComponents.COOKING_FUEL, new net.minecraft.world.item.component.CookingFuel(
                    new net.minecraft.util.valueproviders.ResolvableInt.Constant(
                        <#if hasProcedure(extension.fuelPower)>
                            (int) <@procedureOBJToNumberCode extension.fuelPower/>
                        <#else>
                            ${extension.fuelPower.getFixedValue()}
                        </#if>
                    ),
                    net.minecraft.util.valueproviders.ResolvableFloat.fromKey(net.minecraft.util.context.ContextFloatProviders.COOKING_DEFAULT_SPEED_MULTIPLIER)
                ));
            });
            </#list>
        });
        </#if>
	}
}</@javacompress>
<#-- @formatter:on -->
