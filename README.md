# nvim-dto-converter

A Neovim plugin that converts C# DTO (Data Transfer Objects) to TypeScript DTOs.
The signature is:
```
require("FromC#ToTypeScript").convertDto(<socket port>, <register>)
```
It takes the string from the <register> and replace the converted text.

## Install
  use { "Wordluc/FromC-ToTypeScript", branch = "master" }

