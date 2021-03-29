## WAF
##### Running Offset
<img src=./results/TRIM_ON_OFF/Offset_ON_OFF_cut_init.png width="450px" height="300px" title="TRIM_OFF_cun_waf" alt="TRIM_OFF_cun_waf"></img><br/>

##### Cumulative Offset
<img src=./results/TRIM_ON_OFF/Offset_CUM.png width="450px" height="300px" title="TRIM_OFF_cun_waf" alt="TRIM_OFF_cun_waf"></img><br/>

##### run_waf
<img src=./results/TRIM_ON_OFF/conclusion/run_waf_ON_OFF.png width="450px" height="300px" title="TRIM_OFF_cun_waf" alt="TRIM_OFF_cun_waf"></img><br/>

##### cum_waf
<img src=./results/TRIM_ON_OFF/conclusion/cum_waf_ON_OFF.png width="450px" height="300px" title="TRIM_OFF_cun_waf" alt="TRIM_OFF_cun_waf"></img><br/>


##### Notation
- ON : Trim ON
- OFF : Trim OFF
- LBA : Logical Block Address (seen on Host)
- SSD : Physical Block Address (used by SSD in addition to Host request)
- RW : Running WAF
- CW : Cumulative WAF
- OPS : Operation per Second

##### Analysis
When the TRIM option was set ON, the logical pages used by host was more than when the option was set OFF.   \
When the option was set ON, the number of operations per time unit is larger than when the option was set OFF. It means it writes more pages logically when using TRIM. This brings greater differencs in WAF. WAF is caculated as (LBA + SSD)/LBA. When LBA gets large, WAF value gets smaller. And even SSD value is smaller when using TRIM. This is due to the more efficient garbage collection.
