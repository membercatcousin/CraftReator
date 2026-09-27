<#assign config = configurationcode?trim>
<#if config?starts_with("{") && config?ends_with("}")>
  <#assign inner = config[1..(config?length - 2)]>
<#else>
  <#assign inner = config>
</#if>
{
  "type": <#if data.hasGenerationConditions()>"${modid}:${registryname}"<#else>"${generator.map(featuretype, "features", 2)?replace("@modid",modid)}"</#if><#if inner?trim?has_content>,</#if>
  ${inner}
}
