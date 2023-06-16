-- This file can be loaded by calling `lua require('plugins')` from your init.vim
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- Put your plugins here
  use {
	  'nvim-telescope/telescope.nvim', tag = '0.1.1',
	  requires = { {'nvim-lua/plenary.nvim'} }
  }

  use 'EdenEast/nightfox.nvim'
  
  use('nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'})
  
  use 'mbbill/undotree'

  use 'tpope/vim-fugitive'
  
  use 'norcalli/nvim-colorizer.lua'
 
  -- This is to bootstrap packer on new vim installs
  -- Keep it at the end of plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)
