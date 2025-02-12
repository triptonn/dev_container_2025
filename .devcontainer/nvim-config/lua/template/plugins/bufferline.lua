return {
  "akinsho/bufferline.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  version = "*",
  opts = {
    options = {
      mode = 'tabs',
      numbers = function(opts)
        return string.format('%s|%s', opts.ordinal, opts.raise(opts.id))
      end,
    },
  },
}
