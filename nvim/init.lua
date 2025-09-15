-- Neovim Configuration with Enhanced Debugging & Modern Plugins
-- ~/.config/nvim/init.lua

-- ========================================
-- BASIC SETTINGS
-- ========================================

-- Set leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Basic editor settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"
vim.opt.syntax = "on"
vim.opt.termguicolors = true

-- File type settings
vim.opt.filetype = "on"
vim.cmd("filetype plugin indent on")

-- Tab and indentation
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true

-- Search settings
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Visual settings
vim.opt.laststatus = 2
vim.opt.cursorline = true
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.colorcolumn = "80"

-- Split settings
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Better backups and swaps
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false
vim.opt.undodir = vim.fn.stdpath("data") .. "/undodir"
vim.opt.undofile = true

-- Performance
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

-- ========================================
-- YOUR VIM CUSTOMIZATIONS
-- ========================================

-- jk to escape in insert mode
vim.keymap.set("i", "jk", "<Esc>", { desc = "Exit insert mode" })

-- H and L for beginning and end of line
vim.keymap.set("n", "H", "0", { desc = "Go to beginning of line" })
vim.keymap.set("n", "L", "$", { desc = "Go to end of line" })

-- Enhanced Python execution with debugging support
local function setup_python_keymaps()
    vim.keymap.set("i", "<F2>", "<Esc>:w<CR>:!clear;python %<CR>", { buffer = true, desc = "Save and run Python" })
    vim.keymap.set("n", "<F2>", ":w<CR>:!clear;python %<CR>", { buffer = true, desc = "Save and run Python" })
    vim.keymap.set("n", "<F3>", ":w<CR>:!clear;python -m pdb %<CR>",
        { buffer = true, desc = "Save and debug Python with pdb" })
    vim.keymap.set("n", "<leader>py", ":w<CR>:TermExec cmd='python %'<CR>",
        { buffer = true, desc = "Run Python in terminal" })
    vim.keymap.set("n", "<leader>pd", ":w<CR>:TermExec cmd='python -m pdb %'<CR>",
        { buffer = true, desc = "Debug Python in terminal" })
end

-- Auto-command to set Python keymaps for Python files
vim.api.nvim_create_autocmd("FileType", {
    pattern = "python",
    callback = setup_python_keymaps,
})

-- JavaScript/TypeScript execution
local function setup_js_keymaps()
    vim.keymap.set("n", "<F2>", ":w<CR>:!clear;node %<CR>", { buffer = true, desc = "Save and run with Node.js" })
    vim.keymap.set("n", "<leader>js", ":w<CR>:TermExec cmd='node %'<CR>", { buffer = true, desc = "Run JS in terminal" })
end

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "javascript", "typescript" },
    callback = setup_js_keymaps,
})

-- Toggle mouse mode (fixed version)
vim.keymap.set("n", "<leader>m", function()
    local current_mouse = vim.o.mouse
    if current_mouse == "a" then
        vim.o.mouse = ""
        print("Mouse disabled")
    else
        vim.o.mouse = "a"
        print("Mouse enabled")
    end
end, { desc = "Toggle mouse mode" })

-- ========================================
-- BOOTSTRAP LAZY.NVIM
-- ========================================

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- ========================================
-- PLUGIN CONFIGURATION
-- ========================================

require("lazy").setup({
    -- ========================================
    -- COLORSCHEMES
    -- ========================================
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        config = function()
            require("catppuccin").setup({
                flavour = "mocha", -- latte, frappe, macchiato, mocha
                transparent_background = false,
                integrations = {
                    telescope = true,
                    nvimtree = true,
                    gitsigns = true,
                    treesitter = true,
                    cmp = true,
                    dap = true,
                    dap_ui = true,
                    which_key = true,
                },
            })
        end,
    },

    -- Snazzy colorscheme
    {
        "connorholyday/vim-snazzy",
        priority = 1000,
    },

    -- Gruvbox colorscheme
    {
        "ellisonleao/gruvbox.nvim",
        priority = 1000,
        config = function()
            require("gruvbox").setup({
                terminal_colors = true,
                undercurl = true,
                underline = true,
                bold = true,
                italic = {
                    strings = true,
                    emphasis = true,
                    comments = true,
                    operators = false,
                    folds = true,
                },
                strikethrough = true,
                invert_selection = false,
                invert_signs = false,
                invert_tabline = false,
                invert_intend_guides = false,
                inverse = true,
                contrast = "", -- can be "hard", "soft" or empty string
                palette_overrides = {},
                overrides = {},
                dim_inactive = false,
                transparent_mode = false,
            })
        end,
    },

    -- ========================================
    -- SEARCH AND REPLACE
    -- ========================================
    {
        "MagicDuck/grug-far.nvim",
        config = function()
            require("grug-far").setup({
                -- Options can be added here if needed
                -- Default options work well for most use cases

                -- Example customizations:
                -- engine = 'ripgrep', -- ripgrep (default) or astgrep
                -- startInInsertMode = false,
                -- wrap = true,
                -- transient = false,

                -- You can customize keymaps within the grug-far buffer
                -- See :help grug-far-usage for more details
            })
        end,
    },

    -- ========================================
    -- FILE MANAGER
    -- ========================================
    -- Yazi file manager integration
    {
        "mikavilpas/yazi.nvim",
        event = "VeryLazy",
        keys = {
            {
                "<leader>-",
                "<cmd>Yazi<cr>",
                desc = "Open yazi at the current file",
            },
            {
                "<leader>cw",
                "<cmd>Yazi cwd<cr>",
                desc = "Open yazi in current working directory",
            },
        },
        opts = {
            -- Set to `false` if you want to replace netrw entirely
            open_for_directories = false,
            -- Change working directory when navigating
            use_ya_for_events_reading = true,
            use_yazi_client_id_flag = true,
            log_level = vim.log.levels.OFF,
            -- Enhanced directory change with nvim-tree refresh
            set_keymappings_function = function(yazi_buffer, config, context)
                -- Set up keymap to change directory using current yazi directory
                vim.keymap.set("n", "<c-d>", function()
                    local yazi_cwd = nil

                    -- Debug: print what we have in context
                    if context then
                        print("Debug - Context keys: " .. vim.inspect(vim.tbl_keys(context)))
                    end

                    -- Method 1: Try to get from yazi context (most reliable)
                    if context then
                        -- Look for various directory fields in context
                        if context.current_directory then
                            yazi_cwd = context.current_directory
                        elseif context.last_directory then
                            yazi_cwd = context.last_directory
                        elseif context.file_path then
                            yazi_cwd = vim.fn.fnamemodify(context.file_path, ":h")
                        elseif context.cwd then
                            yazi_cwd = context.cwd
                        elseif context.dir then
                            yazi_cwd = context.dir
                        elseif context.pwd then
                            yazi_cwd = context.pwd
                        end
                    end

                    -- Method 2: Try to use yazi config state
                    if not yazi_cwd and config then
                        if config.cwd then
                            yazi_cwd = config.cwd
                        elseif config.current_directory then
                            yazi_cwd = config.current_directory
                        end
                    end

                    -- Method 3: Try to get from environment or yazi state
                    if not yazi_cwd then
                        -- Check if there's a yazi temp file with current directory
                        local yazi_tmp = "/tmp/yazi-cwd-" .. vim.fn.getpid()
                        local f = io.open(yazi_tmp, "r")
                        if f then
                            yazi_cwd = f:read("*all"):gsub("%s+", "")
                            f:close()
                        end
                    end

                    -- Method 4: Prompt user for directory (as fallback)
                    if not yazi_cwd or yazi_cwd == "" or yazi_cwd == "./" then
                        vim.ui.input({
                            prompt = "Enter directory to change to: ",
                            default = vim.fn.getcwd(),
                            completion = "dir",
                        }, function(input)
                            if input and input ~= "" then
                                yazi_cwd = input
                                -- Continue with the directory change process
                                change_directory_and_sync(yazi_cwd)
                            end
                        end)
                        return -- Exit early since we're using async input
                    end

                    change_directory_and_sync(yazi_cwd)

                    -- Close yazi and return to current file
                    vim.api.nvim_buf_delete(yazi_buffer, { force = true })
                end, { buffer = yazi_buffer })

                -- Helper function to change directory and sync nvim-tree
                local function change_directory_and_sync(target_dir)
                    -- Ensure the path is absolute and clean
                    target_dir = vim.fn.fnamemodify(target_dir, ":p")
                    if target_dir:sub(-1) == "/" then
                        target_dir = target_dir:sub(1, -2)
                    end

                    print("Attempting to change to: " .. target_dir)

                    -- Change to the directory - use multiple methods to ensure it works
                    local success = false
                    local err = nil

                    -- Method 1: Use vim.fn.chdir (more reliable)
                    success, err = pcall(vim.fn.chdir, target_dir)

                    -- Method 2: Fallback to vim.cmd if chdir fails
                    if not success then
                        success, err = pcall(function()
                            vim.cmd("cd " .. vim.fn.fnameescape(target_dir))
                        end)
                    end

                    -- Method 3: Direct lua os change as last resort
                    if not success then
                        success, err = pcall(function()
                            vim.loop.chdir(target_dir)
                            vim.cmd("cd " .. vim.fn.fnameescape(target_dir))
                        end)
                    end

                    if success then
                        -- Enhanced nvim-tree synchronization - handle this BEFORE changing directory
                        local ok, nvim_tree_api = pcall(require, "nvim-tree.api")
                        local tree_was_visible = false

                        if ok and nvim_tree_api.tree.is_visible() then
                            tree_was_visible = true
                            -- Close nvim-tree first to prevent it from interfering
                            nvim_tree_api.tree.close()
                        end

                        -- Now verify the directory actually changed
                        local actual_cwd = vim.fn.getcwd()
                        print("Changed directory to: " .. actual_cwd)

                        -- Re-open and sync nvim-tree if it was visible
                        if ok and tree_was_visible then
                            vim.defer_fn(function()
                                -- Change the root first, then open
                                nvim_tree_api.tree.change_root(actual_cwd)
                                nvim_tree_api.tree.open()

                                -- Double-check and force sync after opening
                                vim.defer_fn(function()
                                    local final_cwd = vim.fn.getcwd()
                                    if final_cwd ~= actual_cwd then
                                        -- Force change the directory again if nvim-tree changed it
                                        vim.fn.chdir(actual_cwd)
                                        print("Re-synced directory to: " .. actual_cwd)
                                    end
                                end, 100)
                            end, 100)
                        elseif ok then
                            -- Just change root if tree is not visible
                            nvim_tree_api.tree.change_root(actual_cwd)
                        end

                        -- Write to temp file for shell integration
                        local temp_file = "/tmp/nvim_yazi_cwd"
                        local f = io.open(temp_file, "w")
                        if f then
                            f:write(actual_cwd)
                            f:close()
                        end
                    else
                        print("Failed to change directory: " .. (err or "unknown error"))
                    end
                end
            end,
            keymaps = {
                show_help = '<f1>',
                open_file_in_vertical_split = '<c-v>',
                open_file_in_horizontal_split = '<c-x>',
                open_file_in_tab = '<c-t>',
                grep_in_directory = '<c-s>',
                replace_in_directory = '<c-g>',
                cycle_open_buffers = '<tab>',
                copy_relative_path_to_selected_files = '<c-y>',
                send_to_quickfix_list = '<c-q>',
                change_working_directory = '<c-d>',
            },
        },
    },

    -- ========================================
    -- FILE EXPLORER
    -- ========================================
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = "nvim-tree/nvim-web-devicons",
        config = function()
            require("nvim-tree").setup({
                view = {
                    width = 60,
                    side = "left",
                },
                renderer = {
                    group_empty = true,
                    icons = {
                        show = {
                            file = true,
                            folder = true,
                            folder_arrow = true,
                            git = true,
                        },
                    },
                },
                filters = {
                    dotfiles = false,
                },
                git = {
                    enable = true,
                },
                actions = {
                    open_file = {
                        quit_on_open = false,
                        window_picker = {
                            enable = true,
                        },
                    },
                },
                hijack_cursor = false,
                disable_netrw = true,
                hijack_netrw = true,
                sync_root_with_cwd = true,
                respect_buf_cwd = true,
                prefer_startup_root = false,
                update_focused_file = {
                    enable = true,
                    update_root = false, -- Don't let nvim-tree change the root automatically
                },
            })
        end,
    },

    -- ========================================
    -- FUZZY FINDER
    -- ========================================
    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        },
        config = function()
            require("telescope").setup({
                defaults = {
                    mappings = {
                        i = {
                            ["<C-k>"] = require("telescope.actions").move_selection_previous,
                            ["<C-j>"] = require("telescope.actions").move_selection_next,
                            ["<C-q>"] = require("telescope.actions").send_to_qflist +
                                require("telescope.actions").open_qflist,
                        },
                    },
                    file_ignore_patterns = {
                        "node_modules",
                        ".git/",
                        "__pycache__",
                        "*.pyc",
                    },
                },
            })
            require("telescope").load_extension("fzf")
        end,
    },

    -- ========================================
    -- TREESITTER (SYNTAX HIGHLIGHTING)
    -- ========================================
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        dependencies = {
            "nvim-treesitter/nvim-treesitter-textobjects",
        },
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = {
                    "lua", "vim", "vimdoc", "python", "javascript", "typescript", "html", "css",
                    "json", "yaml", "markdown", "bash", "c", "cpp", "java", "go", "rust", "toml"
                },
                auto_install = true,
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },
                indent = { enable = true },
                textobjects = {
                    select = {
                        enable = true,
                        lookahead = true,
                        keymaps = {
                            ["af"] = "@function.outer",
                            ["if"] = "@function.inner",
                            ["ac"] = "@class.outer",
                            ["ic"] = "@class.inner",
                        },
                    },
                },
            })
        end,
    },

    -- ========================================
    -- LSP CONFIGURATION
    -- ========================================
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup({
                ui = {
                    icons = {
                        package_installed = "✓",
                        package_pending = "➜",
                        package_uninstalled = "✗"
                    }
                }
            })
        end,
    },

    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "mason.nvim" },
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "lua_ls",
                    "pyright",
                    "ts_ls", -- Updated from tsserver
                    "html",
                    "cssls",
                    "jsonls",
                    "bashls",
                },
                automatic_installation = true,
            })
        end,
    },

    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "mason.nvim",
            "mason-lspconfig.nvim",
            "hrsh7th/cmp-nvim-lsp",
        },
        config = function()
            local lspconfig = require("lspconfig")
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            -- Enhanced LSP handlers
            vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
                border = "rounded",
            })

            vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
                border = "rounded",
            })

            -- LSP servers setup
            local servers = { "lua_ls", "pyright", "ts_ls", "html", "cssls", "jsonls", "bashls" }

            for _, server in ipairs(servers) do
                lspconfig[server].setup({
                    capabilities = capabilities,
                })
            end

            -- Special setup for lua_ls
            lspconfig.lua_ls.setup({
                capabilities = capabilities,
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { "vim" },
                        },
                        workspace = {
                            library = vim.api.nvim_get_runtime_file("", true),
                        },
                    },
                },
            })

            -- Enhanced Python setup
            lspconfig.pyright.setup({
                capabilities = capabilities,
                settings = {
                    python = {
                        analysis = {
                            autoSearchPaths = true,
                            useLibraryCodeForTypes = true,
                            diagnosticMode = "workspace",
                        },
                    },
                },
            })
        end,
    },

    -- ========================================
    -- DEBUGGING (DAP)
    -- ========================================
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "rcarriga/nvim-dap-ui",
            "theHamsta/nvim-dap-virtual-text",
            "nvim-neotest/nvim-nio",
        },
        config = function()
            local dap = require("dap")
            local dapui = require("dapui")

            dapui.setup()
            require("nvim-dap-virtual-text").setup()

            -- Python DAP configuration
            dap.adapters.python = {
                type = "executable",
                command = "python",
                args = { "-m", "debugpy.adapter" },
            }

            dap.configurations.python = {
                {
                    type = "python",
                    request = "launch",
                    name = "Launch file",
                    program = "${file}",
                    pythonPath = function()
                        return "/usr/bin/python3"
                    end,
                },
            }

            -- Node.js DAP configuration
            dap.adapters.node2 = {
                type = "executable",
                command = "node",
                args = { vim.fn.stdpath("data") .. "/mason/packages/node-debug2-adapter/node_modules/node-debug2/out/src/nodeDebug.js" },
            }

            dap.configurations.javascript = {
                {
                    name = "Launch",
                    type = "node2",
                    request = "launch",
                    program = "${file}",
                    cwd = vim.fn.getcwd(),
                    sourceMaps = true,
                    protocol = "inspector",
                    console = "integratedTerminal",
                },
            }

            -- Auto open/close DAP UI
            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close()
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close()
            end
        end,
    },

    -- ========================================
    -- AUTOCOMPLETION
    -- ========================================
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
            "rafamadriz/friendly-snippets",
        },
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")

            require("luasnip.loaders.from_vscode").lazy_load()

            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-k>"] = cmp.mapping.select_prev_item(),
                    ["<C-j>"] = cmp.mapping.select_next_item(),
                    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<CR>"] = cmp.mapping.confirm({ select = false }),
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                }, {
                    { name = "buffer" },
                    { name = "path" },
                }),
            })
        end,
    },

    -- ========================================
    -- GIT INTEGRATION
    -- ========================================
    {
        "lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup({
                signs = {
                    add = { text = "+" },
                    change = { text = "~" },
                    delete = { text = "_" },
                    topdelete = { text = "‾" },
                    changedelete = { text = "~" },
                },
                current_line_blame = true,
                current_line_blame_opts = {
                    virt_text = true,
                    virt_text_pos = "eol",
                    delay = 1000,
                },
            })
        end,
    },

    {
        "tpope/vim-fugitive",
    },

    -- ========================================
    -- STATUS LINE
    -- ========================================
    {
        "nvim-lualine/lualine.nvim",
        dependencies = "nvim-tree/nvim-web-devicons",
        config = function()
            require("lualine").setup({
                options = {
                    theme = "auto", -- Will adapt to current colorscheme
                    section_separators = "",
                    component_separators = "|",
                },
                sections = {
                    lualine_a = { "mode" },
                    lualine_b = { "branch", "diff", "diagnostics" },
                    lualine_c = { "filename" },
                    lualine_x = { "encoding", "fileformat", "filetype" },
                    lualine_y = { "progress" },
                    lualine_z = { "location" }
                },
            })
        end,
    },

    -- ========================================
    -- WHICH-KEY (KEY MAPPING HELPER)
    -- ========================================
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        config = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
            require("which-key").setup()
        end,
    },

    -- ========================================
    -- ADDITIONAL USEFUL PLUGINS
    -- ========================================
    {
        "kylechui/nvim-surround",
        version = "*", -- Use for stability; omit to use `main` branch for the latest features
        event = "VeryLazy",
        config = function()
            require("nvim-surround").setup({
                -- Configuration here, or leave empty to use defaults
            })
        end,
    },

    {
        "windwp/nvim-autopairs",
        config = function()
            require("nvim-autopairs").setup()
        end,
    },

    {
        "numToStr/Comment.nvim",
        config = function()
            require("Comment").setup()
        end,
    },

    {
        "akinsho/toggleterm.nvim",
        config = function()
            require("toggleterm").setup({
                size = 20,
                open_mapping = [[<c-\>]],
                direction = "horizontal",
                shade_terminals = true,
            })
        end,
    },

    -- Improved error display
    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("trouble").setup()
        end,
    },

    -- Better notifications
    {
        "rcarriga/nvim-notify",
        config = function()
            require("notify").setup({
                background_colour = "#000000",
            })
            vim.notify = require("notify")
        end,
    },

    -- Indent guides
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        config = function()
            require("ibl").setup()
        end,
    },
})

-- ========================================
-- SET DEFAULT COLORSCHEME
-- ========================================
-- Options: "catppuccin", "snazzy", "gruvbox"
vim.cmd.colorscheme("catppuccin")

-- ========================================
-- KEY MAPPINGS
-- ========================================

-- Basic mappings (keeping your original style)
vim.keymap.set("n", "<leader>w", ":w<CR>", { desc = "Save file" })
vim.keymap.set("n", "<leader>q", ":q<CR>", { desc = "Quit" })
vim.keymap.set("n", "<leader>x", ":wq<CR>", { desc = "Save and quit" })
vim.keymap.set("n", "<leader>h", ":nohlsearch<CR>", { desc = "Clear search highlighting" })

-- Better window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to bottom window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to top window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- Window splits
vim.keymap.set("n", "<leader>v", ":vsplit<CR>", { desc = "Vertical split" })
vim.keymap.set("n", "<leader>s", ":split<CR>", { desc = "Horizontal split" })

-- Buffer navigation (FIXED: Changed from H/L to <leader>bp/<leader>bn)
vim.keymap.set("n", "<leader>bp", ":bprevious<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "<leader>bn", ":bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>bd", ":bdelete<CR>", { desc = "Delete buffer" })

-- Plugin keymaps
vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "Toggle file explorer" })
vim.keymap.set("n", "<leader>ff", ":Telescope find_files<CR>", { desc = "Find files" })
vim.keymap.set("n", "<leader>fg", ":Telescope live_grep<CR>", { desc = "Live grep" })
vim.keymap.set("n", "<leader>fb", ":Telescope buffers<CR>", { desc = "Find buffers" })
vim.keymap.set("n", "<leader>fh", ":Telescope help_tags<CR>", { desc = "Help tags" })
vim.keymap.set("n", "<leader>fr", ":Telescope oldfiles<CR>", { desc = "Recent files" })

-- Grug-far (Search and Replace) keymaps
vim.keymap.set("n", "<leader>sr", ":GrugFar<CR>", { desc = "Search and Replace" })
vim.keymap.set("n", "<leader>sw", function()
    require("grug-far").grug_far({ prefills = { search = vim.fn.expand("<cword>") } })
end, { desc = "Search and Replace word under cursor" })
vim.keymap.set("v", "<leader>sr", function()
    require("grug-far").with_visual_selection({ prefills = { paths = vim.fn.expand("%") } })
end, { desc = "Search and Replace selection in current file" })

-- ========================================
-- DIRECTORY CHANGE COMMANDS
-- ========================================

-- Directory change with tab completion
vim.keymap.set("n", "<leader>yc", function()
    vim.ui.input({
        prompt = "Change directory: ",
        default = vim.fn.getcwd(),
        completion = "dir",
    }, function(input)
        if input then
            vim.cmd("cd " .. vim.fn.fnameescape(input))
            print("Changed directory to: " .. input)
            -- Force nvim-tree to reload and sync with new cwd
            local nvim_tree_api = require("nvim-tree.api")
            if nvim_tree_api.tree.is_visible() then
                nvim_tree_api.tree.reload()
                nvim_tree_api.tree.change_root(input)
            end
        end
    end)
end, { desc = "Change directory with tab completion" })

-- Quick change to home directory
vim.keymap.set("n", "<leader>yh", function()
    local home = vim.fn.expand("~")
    vim.cmd("cd " .. vim.fn.fnameescape(home))
    print("Changed directory to: " .. home)
    -- Force nvim-tree to reload and sync with new cwd
    local nvim_tree_api = require("nvim-tree.api")
    if nvim_tree_api.tree.is_visible() then
        nvim_tree_api.tree.reload()
        nvim_tree_api.tree.change_root(home)
    end
end, { desc = "Quick change to home directory" })

-- Change to parent directory
vim.keymap.set("n", "<leader>yp", function()
    local parent = vim.fn.expand("%:p:h:h")
    if parent and parent ~= "" then
        vim.cmd("cd " .. vim.fn.fnameescape(parent))
        print("Changed directory to: " .. parent)
        -- Force nvim-tree to reload and sync with new cwd
        local nvim_tree_api = require("nvim-tree.api")
        if nvim_tree_api.tree.is_visible() then
            nvim_tree_api.tree.reload()
            nvim_tree_api.tree.change_root(parent)
        end
    else
        print("Cannot determine parent directory")
    end
end, { desc = "Change to parent directory" })

-- Show current working directory
vim.keymap.set("n", "<leader>yw", function()
    local cwd = vim.fn.getcwd()
    print("Current working directory: " .. cwd)
end, { desc = "Show current working directory" })

-- Enhanced Yazi integration with nvim-tree refresh
local function yazi_cd_with_nvim_tree_refresh()
    require("yazi").yazi({
        on_exit = function(selected_files, config, state)
            if selected_files and #selected_files > 0 then
                local file = selected_files[1]
                local dir = vim.fn.isdirectory(file) == 1 and file or vim.fn.fnamemodify(file, ":h")
                -- Change Neovim directory
                vim.cmd("cd " .. vim.fn.fnameescape(dir))
                -- Force nvim-tree to reload and sync with new cwd
                local nvim_tree_api = require("nvim-tree.api")
                if nvim_tree_api.tree.is_visible() then
                    nvim_tree_api.tree.reload()
                    nvim_tree_api.tree.change_root(dir)
                end
                -- Also change shell directory by writing to a temp file for potential shell integration
                local temp_file = "/tmp/nvim_yazi_cwd"
                local f = io.open(temp_file, "w")
                if f then
                    f:write(dir)
                    f:close()
                end
                print("Changed directory to: " .. dir)
            end
        end
    })
end


-- Colorscheme switching keymaps
vim.keymap.set("n", "<leader>tc", ":colorscheme catppuccin<CR>", { desc = "Catppuccin theme" })
vim.keymap.set("n", "<leader>ts", ":colorscheme snazzy<CR>", { desc = "Snazzy theme" })
vim.keymap.set("n", "<leader>tg", ":colorscheme gruvbox<CR>", { desc = "Gruvbox theme" })

-- Git keymaps
vim.keymap.set("n", "<leader>gs", ":Git<CR>", { desc = "Git status" })
vim.keymap.set("n", "<leader>gc", ":Git commit<CR>", { desc = "Git commit" })
vim.keymap.set("n", "<leader>gp", ":Git push<CR>", { desc = "Git push" })
vim.keymap.set("n", "<leader>gl", ":Git log<CR>", { desc = "Git log" })

-- LSP keymaps
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Go to references" })
vim.keymap.set("n", "gI", vim.lsp.buf.implementation, { desc = "Go to implementation" })
vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover documentation" })
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename" })
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, { desc = "Format" })

-- Debugging keymaps
vim.keymap.set("n", "<F5>", ":lua require'dap'.continue()<CR>", { desc = "Debug: Continue" })
vim.keymap.set("n", "<F10>", ":lua require'dap'.step_over()<CR>", { desc = "Debug: Step Over" })
vim.keymap.set("n", "<F11>", ":lua require'dap'.step_into()<CR>", { desc = "Debug: Step Into" })
vim.keymap.set("n", "<F12>", ":lua require'dap'.step_out()<CR>", { desc = "Debug: Step Out" })
vim.keymap.set("n", "<leader>db", ":lua require'dap'.toggle_breakpoint()<CR>", { desc = "Debug: Toggle Breakpoint" })
vim.keymap.set("n", "<leader>dr", ":lua require'dap'.repl.open()<CR>", { desc = "Debug: Open REPL" })

-- Trouble (error list) keymaps
vim.keymap.set("n", "<leader>xx", ":TroubleToggle<CR>", { desc = "Toggle Trouble" })
vim.keymap.set("n", "<leader>xw", ":TroubleToggle workspace_diagnostics<CR>", { desc = "Workspace diagnostics" })
vim.keymap.set("n", "<leader>xd", ":TroubleToggle document_diagnostics<CR>", { desc = "Document diagnostics" })

-- Terminal keymaps
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- ========================================
-- AUTO COMMANDS
-- ========================================

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
    pattern = "*",
    callback = function()
        vim.highlight.on_yank({ timeout = 200 })
    end,
})

-- Remove trailing whitespace on save
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    callback = function()
        local save_cursor = vim.fn.getpos(".")
        vim.cmd([[%s/\s\+$//e]])
        vim.fn.setpos(".", save_cursor)
    end,
})

-- Auto-format on save for specific file types
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = { "*.lua", "*.py", "*.js", "*.ts" },
    callback = function()
        vim.lsp.buf.format({ async = false })
    end,
})

-- Close certain windows with q
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "qf", "help", "man", "lspinfo", "spectre_panel" },
    callback = function()
        vim.keymap.set("n", "q", ":close<CR>", { buffer = true, silent = true })
    end,
})

-- ========================================
-- DIAGNOSTIC CONFIGURATION
-- ========================================

vim.diagnostic.config({
    virtual_text = {
        prefix = "◉",
    },
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = {
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
    },
})
