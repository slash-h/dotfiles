-- Using igorlfs/nvim-dap-view for debugging UI, therefore exit from here.
-- Check plugins/dap-view.lua
if true then
    return {}
end
vim.api.nvim_create_augroup("DapGroup", { clear = true })

local function navigate(args)
    local buffer = args.buf

    local wid = nil
    local win_ids = vim.api.nvim_list_wins() -- Get all window IDs
    for _, win_id in ipairs(win_ids) do
        local win_bufnr = vim.api.nvim_win_get_buf(win_id)
        if win_bufnr == buffer then
            wid = win_id
        end
    end

    if wid == nil then
        return
    end

    vim.schedule(function()
        if vim.api.nvim_win_is_valid(wid) then
            vim.api.nvim_set_current_win(wid)
        end
    end)
end

local function create_nav_options(name)
    return {
        group = "DapGroup",
        pattern = string.format("*%s*", name),
        callback = navigate
    }
end

return {
    {
        "mfussenegger/nvim-dap",
        lazy = false,
        dependencies = {
            {
                "mason-org/mason.nvim",
                opts = function(_, opts)
                    opts.ensure_installed = opts.ensure_installed or {}
                    table.insert(opts.ensure_installed, "js-debug-adapter")
                end,
            },
        },
        config = function()
            local dap = require("dap")
            dap.set_log_level("DEBUG")

            -- Adapters
            -- Python
            -- require("plugins.dap.debugpy")
            -- JS, TS
            require("plugins.dapconf.js-debug-adapter")

            -- setup dap config by VsCode launch.json file
            local vscode = require("dap.ext.vscode")
            local json = require("plenary.json")
            vscode.json_decode = function(str)
                return vim.json.decode(json.json_strip_comments(str))
            end

            vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })


            local dap_icons = {
                Stopped = { '󰁕 ', 'DiagnosticWarn', 'DapStoppedLine' },
                Breakpoint = ' ',
                BreakpointCondition = ' ',
                BreakpointRejected = { ' ', 'DiagnosticError' },
                LogPoint = '.>',
            }
            for name, sign in pairs(dap_icons) do
                sign = type(sign) == 'table' and sign or { sign }
                vim.fn.sign_define('Dap' .. name, {
                    text = sign[1],
                    texthl = sign[2] or 'DiagnosticInfo',
                    linehl = sign[3],
                    numhl = sign[3],
                })
            end
            vim.keymap.set("n", "<F8>", dap.continue, { desc = "Debug: Continue" })
            vim.keymap.set("n", "<F6>", dap.step_over, { desc = "Debug: Step Over" })
            vim.keymap.set("n", "<F5>", dap.step_into, { desc = "Debug: Step Into" })
            vim.keymap.set("n", "<F7>", dap.step_out, { desc = "Debug: Step Out" })
            vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
            vim.keymap.set("n", "<leader>B", function()
                dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
            end, { desc = "Debug: Set Conditional Breakpoint" })
        end
    },


    {
        "rcarriga/nvim-dap-ui",
        dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
        config = function()
            local dap = require("dap")
            local dapui = require("dapui")

            local function layout(name)
                return {
                    elements = {
                        { id = name },
                    },
                    enter = true,
                    size = 50,
                    position = "right",
                }
            end
            local name_to_layout = {
                repl = { layout = layout("repl"), index = 0 },
                stacks = { layout = layout("stacks"), index = 0 },
                scopes = { layout = layout("scopes"), index = 0 },
                console = { layout = layout("console"), index = 0 },
                watches = { layout = layout("watches"), index = 0 },
                breakpoints = { layout = layout("breakpoints"), index = 0 },
                default_left = { layout = {
                    elements = { { id = "watches", size = 0.25 }, { id = "breakpoints", size = 0.25 },
                                { id = "stacks", size = 0.25 }, { id = "scopes", size = 0.25 } },
                    position = "left",
                    size = 45
                }, index = 0 },

                default_bottom = { layout = {
                    elements = { { id = "console", size = 0.5 }, { id = "repl", size = 0.5 } },
                    position = "bottom",
                    size = 10
                } , index = 0 }
            }

            local layouts = {}

            for name, config in pairs(name_to_layout) do
                table.insert(layouts, config.layout)
                name_to_layout[name].index = #layouts
            end

            local function toggle_debug_ui(name)
                dapui.close()

                local layout_config = name_to_layout[name]

                if layout_config == nil then
                    error(string.format("bad name: %s", name))
                end

                local uis = vim.api.nvim_list_uis()[1]
                if uis ~= nil then
                    layout_config.size = uis.width
                end

                pcall(dapui.toggle, layout_config.index)
            end

            local function toggle_default_debug_ui()
                dapui.close()
                local layout_config = name_to_layout['default_bottom']

                local uis = vim.api.nvim_list_uis()[1]
                if uis ~= nil then
                    layout_config.size = uis.width
                end

                pcall(dapui.toggle, layout_config.index)

                layout_config = name_to_layout['default_left']
                pcall(dapui.toggle, layout_config.index)
            end


            vim.keymap.set("n", "<leader>dr", function() toggle_debug_ui("repl") end, { desc = "Debug: toggle repl ui" })
            vim.keymap.set("n", "<leader>dS", function() toggle_debug_ui("stacks") end, { desc = "Debug: toggle stacks ui" })
            vim.keymap.set("n", "<leader>dw", function() toggle_debug_ui("watches") end, { desc = "Debug: toggle watches ui" })
            vim.keymap.set("n", "<leader>db", function() toggle_debug_ui("breakpoints") end, { desc = "Debug: toggle breakpoints ui" })
            vim.keymap.set("n", "<leader>ds", function() toggle_debug_ui("scopes") end, { desc = "Debug: toggle scopes ui" })
            vim.keymap.set("n", "<leader>dc", function() toggle_debug_ui("console") end, { desc = "Debug: toggle console ui" })
            vim.keymap.set("n", "<leader>df", function() toggle_default_debug_ui() end, { desc = "Debug: toggle default ui" })
            vim.keymap.set("n", "<leader>dwa", function() dapui.elements.watches.add(vim.fn.expand('<cword>')) end, 
                { desc = "Debug: add expression to watches ui" })

            vim.api.nvim_create_autocmd("BufEnter", {
                group = "DapGroup",
                pattern = "*dap-repl*",
                callback = function()
                    vim.wo.wrap = true
                end,
            })

            vim.api.nvim_create_autocmd("BufWinEnter", create_nav_options("dap-repl"))
            vim.api.nvim_create_autocmd("BufWinEnter", create_nav_options("DAP Watches"))

            dapui.setup({
                layouts = layouts,
                enter = true,
            })

            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open(name_to_layout['default_bottom'].index)
                dapui.open(name_to_layout['default_left'].index)
            end
            dap.listeners.before.event_terminated.dapui_config = function()
                dapui.close()
            end
            dap.listeners.before.event_exited.dapui_config = function()
                dapui.close()
            end

            dap.listeners.after.event_output.dapui_config = function(_, body)
                if body.category == "console" then
                    dapui.eval(body.output) -- Sends stdout/stderr to Console
                end
            end
        end,
    },

    {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = {
            "williamboman/mason.nvim",
            "mfussenegger/nvim-dap",
            "neovim/nvim-lspconfig",
        },
        config = function()
            require("mason-nvim-dap").setup({
                ensure_installed = {
                    "js-debug-adapter",
                },
                automatic_installation = true,
                handlers = {},
            })
        end,
    },
}
