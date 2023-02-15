flutter build web --web-renderer canvaskit --release --base-href "/rogue_shooter_backbone/example/"
rm -r docs/example/
cp -R build/web docs/example