<#--
 # MCreator (https://mcreator.net/)
 # Copyright (C) 2012-2020, Pylo
 # Copyright (C) 2020-2023, Pylo, opensource contributors
 #
 # This program is free software: you can redistribute it and/or modify
 # it under the terms of the GNU General Public License as published by
 # the Free Software Foundation, either version 3 of the License, or
 # (at your option) any later version.
 #
 # This program is distributed in the hope that it will be useful,
 # but WITHOUT ANY WARRANTY; without even the implied warranty of
 # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 # GNU General Public License for more details.
 #
 # You should have received a copy of the GNU General Public License
 # along with this program.  If not, see <https://www.gnu.org/licenses/>.
-->

<#-- @formatter:off -->

package ${package}.mixin;

import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.Unique;
import com.llamalad7.mixinextras.injector.wrapmethod.WrapMethod;
import com.llamalad7.mixinextras.injector.wrapoperation.Operation;

import net.minecraft.world.level.levelgen.NoiseGeneratorSettings;
import net.minecraft.world.level.levelgen.material.rule.MaterialRule;
import net.minecraft.world.level.dimension.DimensionType;
import net.minecraft.core.Holder;

@Mixin(NoiseGeneratorSettings.class) public class NoiseGeneratorSettingsMixin implements ${JavaModName}Biomes.${JavaModName}NoiseGeneratorSettings {

        @Unique private Holder<DimensionType> ${modid}_dimensionTypeReference;

        @WrapMethod(method = "materialRule")
        public Holder<MaterialRule> materialRule(Operation<Holder<MaterialRule>> original) {
                Holder<MaterialRule> retval = original.call();
                if (this.${modid}_dimensionTypeReference != null) {
                        retval = ${JavaModName}Biomes.adaptMaterialRule(retval, this.${modid}_dimensionTypeReference);
                }
                return retval;
        }

        @Override public void set${modid}DimensionTypeReference(Holder<DimensionType> dimensionType) {
                this.${modid}_dimensionTypeReference = dimensionType;
        }

}
