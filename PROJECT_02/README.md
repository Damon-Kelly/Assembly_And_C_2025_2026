# 68000 → x86_64 Assembly Conversion

Converts a 68000K assembly program to x86_64. The program prompts for pairs of integers across three iterations, adds each pair, gets a grand total and then prints the result.

---

## Build & Run

```bash
make          # build the program
./main        # run it
```

---

## Register Mapping

| 68000 | x86_64 | Role |
|---|---|---|
| D3 | r13 | Running sum |
| D4 | r14 | Loop counter |
| D2 | r15 | First num |
| D1 | rax | Second num / return value |

---

## Key Changes from the 68000 Source
 
- **I/O** – `TRAP #15` replaced with raw Linux syscalls (`sys_read`, `sys_write`), requiring explicit string↔integer conversion routines.
- **NEW_LINE subroutine removed** – inlined as a single-byte `sys_write` of `0x0A` (Linux uses LF only, not CRLF).
- **Stack alignment** – four callee-saved pushes + `sub rsp, 8` keeps the stack 16-byte aligned per the System V AMD64 ABI.
---
 
## Security Fixes
 
The original 68000 source notes "No input validation" and "No bounds checking" in three places.
 
**1. Buffer overflow (the main issue)**
`TRAP #15` read with no length limit allows input longer than the destination buffer to overwrite adjacent stack memory, including the return address. Fixed by passing `INPUT_BUF_LEN = 16` as a hard cap to `sys_read`.
 
**2. Input validation**
`string_to_integer` rejects any non-digit character and returns `-1`. The caller re-prompts rather than passing garbage to `register_adder`.
 
**3. Integer overflow**
`register_adder` just adds the two numbers and can still wrap on overflow.
 
---
 
## Tests
 
`test_run_sum.c` calls the assembly functions directly via two thin bridge functions (`asm_bridge_adder`, `asm_bridge_atoi`) that translate C calling conventions into what the assembly expects.
 
| Test | What it checks |
|---|---|
| Simple addition | 10 + 20 == 30 |
| Zero addition | 0 + 0 == 0 |
| String to integer | "123" → 123 |
| Invalid characters | "12a3" → -1 |
| Large number | "999" → 999 |
 
