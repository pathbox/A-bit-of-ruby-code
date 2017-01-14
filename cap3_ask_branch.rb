ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp
