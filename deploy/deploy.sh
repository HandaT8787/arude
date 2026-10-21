#!/bin/bash
set -euo pipefail
export PATH="/home/ubuntu/.rbenv/shims:/home/ubuntu/.rbenv/bin:$PATH"

cd /home/ubuntu/arude

bundle install

RAILS_ENV=production bundle exec rails assets:precompile

if [ "${1:-}" = "--migrate" ]; then
  RAILS_ENV=production bundle exec rails db:migrate
fi

sudo systemctl restart puma

for i in 1 2 3 4 5 6 7 8 9 10; do
  if curl -fsS -o /dev/null http://localhost/up; then
    echo "デプロイ完了"
    exit 0
  fi
  sleep 3
done
  
echo "デプロイ失敗"
exit 1