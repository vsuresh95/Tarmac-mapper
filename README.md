# tarmac-mapper
The script can be used to map each entry in a Tarmac trace from a ARM CPU with actual code, when provided with a disassembly of the code.

## Files required:
1. The tarmac trace output from a simulation or post-silicon trace generation tool.
2. A disassembled file of your code — which can be generated using objdump or elfdump.

## Steps:
Ensure the required files are in the same work directory as the script and with the respective names as coded in the script.
```
perl tarmac_mapping.pl
```

If you have multiple cores/clusters:
```
perl tarmac_mapping.pl <cluster-ID> <core-ID>
```
