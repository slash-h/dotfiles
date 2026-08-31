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

            vim.keymap.set("n", "<F1>", require("dap.ui.widgets").hover, { desc = "DAP Hover" })
            vim.keymap.set("n", "<F6>", dap.step_over, { desc = "Debug: Step Over" })
            vim.keymap.set("n", "<F5>", dap.step_into, { desc = "Debug: Step Into" })
            vim.keymap.set("n", "<F7>", dap.step_out, { desc = "Debug: Step Out" })
            vim.keymap.set("n", "<F8>", dap.continue, { desc = "Debug: Continue" })
            vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
            vim.keymap.set("n", "<leader>B", function()
                dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
            end, { desc = "Debug: Set Conditional Breakpoint" })

            dap.listeners.after.event_initialized["dapview_config"] = function()
                require('dap-view').open()
            end
            dap.listeners.before.event_terminated["dapview_config"] = function()
                require('dap-view').close()
            end
            dap.listeners.before.event_exited["dapview_config"] = function()
                require('dap-view').close()
            end
        end
    },
    {
        "igorlfs/nvim-dap-view",
        ---@module 'dap-view'
        ---@type dapview.Config
        opts = {
            winbar = {
                sections = { "watches", "scopes", "exceptions", "breakpoints", "threads", "repl", "console" },
                default_section = "scopes",
                controls = { enabled = true },
            },
            windows = { size = 0.40, position = "below" },

        },
        keys = {
            { '<leader>dw', function() require('dap-view').jump_to_view("watches") end, desc = 'DAPView: Jump to Watches view', },
            { '<leader>dwa', function() require('dap-view').add_expr() end, desc = 'DAPView: Add expression to Watches view', },
            { '<leader>ds', function() require('dap-view').jump_to_view("scopes") end, desc = 'DAPView: Jump to Scopes view', },
            { '<leader>db', function() require('dap-view').jump_to_view("breakpoints") end, desc = 'DAPView: Jump to Breakpoints view', },
            { '<leader>dS', function() require('dap-view').jump_to_view("threads") end, desc = 'DAPView: Jump to Threads view', },
            { '<leader>dr', function() require('dap-view').jump_to_view("repl") end, desc = 'DAPView: Jump to REPL view', },
            { '<leader>dc', function() require('dap-view').jump_to_view("console") end, desc = 'DAPView: Jump to Console view', },
            { '<F10>', function() require('dap-view').toggle() end, desc = 'Toggle Dap View', },
        },
    },
}
