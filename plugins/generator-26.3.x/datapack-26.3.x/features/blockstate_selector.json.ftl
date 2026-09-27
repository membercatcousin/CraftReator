<#include "mcitems_json.ftl">
<#if field_list$property?size == 0>
"${mappedMCItemToRegistryName(w.itemBlock(field$block))}"
<#else>
{
  "id": "${mappedMCItemToRegistryName(w.itemBlock(field$block))}",
  "Properties": {
    <#list 0..field_list$property?size-1 as i>
    "${field_list$property[i]}": "${field_list$value[i]}"
    <#sep>,</#list>
  }
}
</#if>
