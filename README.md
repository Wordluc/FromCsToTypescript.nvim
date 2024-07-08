# nvim-dto-converter

A Neovim plugin that converts C# DTO (Data Transfer Objects) to TypeScript DTOs.
The signature is:
```
require("FromC#ToTypeScript").convertDto(<register>)
```
It takes optionally the register(by default it uses "" ) to get(the code to covert) and store the converted result

## Install
  use { "Wordluc/FromC-ToTypeScript", branch = "master" }

