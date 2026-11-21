# UniversalSynSaveInstance — Single Repository Bundle

This branch keeps the original project tree and adds the runtime helper sources under `vendor/`.

## Run

Execute this one-liner in the supported environment:

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/naells/UniversalSynSaveInstance/self-contained-bundle/loader.luau", true))()
```

The loader fetches `saveinstance.luau` from this branch, redirects the helper URLs to this branch's `vendor/` directory, compiles the source, then runs it.

By default it uses `Binary = false` (XML output). This avoids the Binary `SecurityCapabilities` encoder compatibility error previously observed with this source snapshot. The Binary mode has not been fixed or verified.

## Included runtime helpers

- `vendor/SomeHub/StreamBuffer.luau`: repository-maintained compatible buffer writer.
- `vendor/SomeHub/UniversalMethodFinder.luau`: CC0 helper; license is beside the file.
- `vendor/rbx-algorithms/Base64.luau`: Base64 fallback from daily3014; MIT license included.
- `vendor/llz4/llz4.luau`: LZ4 fallback from RiskoZoSlovenska; MIT license included.

The original project `LICENSE` is retained unchanged.

## What remains online

Roblox API dumps and version metadata are changing platform data, so they remain external. The source keeps official Roblox CDN/client-settings endpoints as its primary source and its existing remote API-dump fallbacks. The bundle is self-contained for runtime helper code, not an offline mirror of every Roblox API dump.

## Branch isolation

All bundle additions are in `self-contained-bundle`. The original `main` branch has not been modified.

## Source integrity

The two main USSI source files and developer Tools are preserved from the base repository. The loader performs URL replacements in memory; it does not edit the upstream source text at runtime.