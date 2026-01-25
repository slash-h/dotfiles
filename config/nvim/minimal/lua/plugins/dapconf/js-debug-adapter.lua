local dap = require("dap")

for _, adapter in pairs({ "node", "chrome" }) do
    local pwa_adapter = "pwa-" .. adapter

    -- Handle launch.json configurations
    -- which specify type as "node" or "chrome"
    -- Inspired by https://github.com/StevanFreeborn/nvim-config/blob/main/lua/plugins/debugging.lua#L111-L123

    -- Main adapter
    dap.adapters[pwa_adapter] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
            command = "js-debug-adapter",
            args = { "${port}" },
        },
        enrich_config = function(config, on_config)
            -- Under the hood, always use the main adapter
            config.type = pwa_adapter
            on_config(config)
        end,
    }

    -- Dummy adapter, redirects to the main one
    dap.adapters[adapter] = dap.adapters[pwa_adapter]
end

local enter_launch_url = function()
			local co = coroutine.running()
			return coroutine.create(function()
				vim.ui.input({ prompt = "Enter URL: ", default = "http://localhost:" }, function(url)
					if url == nil or url == "" then
						return
					else
						coroutine.resume(co, url)
					end
				end)
			end)
		end


for _, language in ipairs({ "typescript", "javascript", "typescriptreact", "javascriptreact", "vue" }) do
    dap.configurations[language] = {
        {
            type = "pwa-node",
            request = "launch",
            name = "Launch file using Node.js (nvim-dap)",
            program = "${file}",
            cwd = "${workspaceFolder}",
        },
        {
            type = "pwa-node",
            request = "attach",
            name = "Attach to process using Node.js (nvim-dap)",
            processId = require("dap.utils").pick_process,
            cwd = "${workspaceFolder}",
        },
        -- requires ts-node to be installed globally or locally
        {
            type = "pwa-node",
            request = "launch",
            name = "Launch file using Node.js with ts-node/register (nvim-dap)",
            program = "${file}",
            cwd = "${workspaceFolder}",
            runtimeArgs = { "-r", "ts-node/register" },
        },
        {
            type = "pwa-chrome",
            request = "launch",
            name = "Launch Chrome (nvim-dap)",
            url = enter_launch_url,
            webRoot = "${workspaceFolder}",
            sourceMaps = true,
        },
    }
end
