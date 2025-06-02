cd gateway
del -Recurse -Force app
cd ..

cd medvedi_stezka_frontend
npm install
npm run build
cd ..

docker compose up --build