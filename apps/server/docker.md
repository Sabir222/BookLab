docker run --name postgres-reservation \
 -e POSTGRES_PASSWORD=sabir10win \
 -e POSTGRES_USER=sabir \
 -e POSTGRES_DB=reservationdb \
 -p 5432:5432 \
 -v postgres_data:/var/lib/postgresql/data \
 -d postgres
