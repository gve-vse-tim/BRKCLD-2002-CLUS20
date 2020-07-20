conda create -n clus20_django python~=3.8
conda activate clus20_django
pip install django

django-admin startproject clus20_django

mkdir pgsql
docker run -d --name clus20_pgsql -p 5432:5432 \
    -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=postgres \
    -e POSTGRES_DB=clus20_database -e PGDATA=/var/lib/postgresql/data \
    -v $PWD/pgsql:/var/lib/postgresql/data \
    postgres

docker exec -it clus20_pgsql /bin/bash
docker exec -it clus20_pgsql psql -U postgres clus20_database
brew install postgresql
pip install psycopg2

python manage.py startapp polls
python manage.py migrate
python manage.py makemigrations polls
python manage.py migrate