local M = {}

local function normalize_src(src)
    if src:match("^[a-z]+://") then
        return src
    end
    return "https://github.com/" .. src:gsub("^/", "")
end

--- installs plugin specs via vim.pack.add, then runs each spec's config()
---@param specs_ext table[] plugin specs, each optionally with `dependencies` and `config`
function M.setup(specs_ext)
    local specs = {}
    local configs = {}

    for _, spec in ipairs(specs_ext) do
        if spec.dependencies then
            for _, dep in ipairs(spec.dependencies) do
                table.insert(specs, { src = normalize_src(dep.src), version = dep.version })
            end
        end
        table.insert(specs, vim.tbl_extend("force", spec, { src = normalize_src(spec.src) }))
        if spec.config then
            table.insert(configs, spec.config)
        end
    end

    vim.pack.add(specs)

    for _, config in ipairs(configs) do
        config()
    end
end

return M
