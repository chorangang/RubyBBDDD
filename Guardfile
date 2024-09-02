guard 'puma', port: 3000 do
  watch(%r{^src/.*\.rb$})
  watch(%r{^config/.*\.rb$})
  watch('config.ru')
  watch('Gemfile.lock')
end