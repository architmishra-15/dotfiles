# What is it?

These are something called `dotfiles` that are used for defining how the program would work/behave, it is used for customizing programs.

## How to use it?

#### nvim -
- Clone the repo using -
    ```bash
    git clone https://github.com/architmishra-15/dotfiles.git
    ```
- Place the nvim folder inside `~/.config/`
- Open `nvim` and run `:Lazy install` (or you can also run `:Lazy sync`)
- **Done**

#### tmux -

- Copy the `.tmux.conf` to `~/` 
- Run `tmux source-file ~/.tmux.conf`

#### helix-

- Place the `helix` directory in `~/.config/` (On Unix-like systems)
- For windows -
    - Press `Win + R` and type `%AppData%`
    - Copy the `helix` folder inside this path.
- Open helix and run -
```vim
:config-reload
```
- **Done**

