<#-- @formatter:off -->
<#include "../mcitems_json.ftl">
{
    "type": "minecraft:brewing",
    <#if data.group?has_content>"group": "${data.group}",</#if>
    "ingredient": {
        ${mappedMCItemToItemObjectJSON(data.brewingIngredientStack, "item")}
    },
    <#if data.brewingInputStack?string?starts_with("POTION:")>
    "input": {
        "item": "minecraft:potion",
        "components": {
            "minecraft:potion_contents": {
                "potion": "${mappedPotionToRegistryName(data.brewingInputStack)}"
            }
        }
    },
    <#else>
    "input": {
        ${mappedMCItemToItemObjectJSON(data.brewingInputStack, "item")}
    },
    </#if>
    <#if data.brewingReturnStack?string?starts_with("POTION:")>
    "output": {
        "id": "minecraft:potion",
        "components": {
            "minecraft:potion_contents": {
                "potion": "${mappedPotionToRegistryName(data.brewingReturnStack)}"
            }
        }
    }
    <#else>
    "output": {
        ${mappedMCItemToItemObjectJSON(data.brewingReturnStack, "id")}
    }
    </#if>
}
<#-- @formatter:on -->s
