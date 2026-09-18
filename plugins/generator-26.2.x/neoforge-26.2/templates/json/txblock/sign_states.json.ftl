{
	"variants": {
		<#list 0..15 as r>
		"rotation=${r}": {
			"model": "${modid}:block/${registryname}_rot_${r % 4}"<#if (r / 4)?int != 0>,
			"y": ${(r / 4)?int * 90}</#if>
		}<#sep>,
		</#list>
	}
}
