
# Airflow-Druid
A demo application of airflow-druid

## Setup

### Step 1: Run Services

**Deep Cleanup**
```
$ make clean-all
```

**Start Airflow**
```
$ make run
```

### Step 2: Populate Connections, Variables and Pools
source environment variables
```
$ export INITDB_FIRSTNAME=admin
$ export INITDB_LASTNAME=admin
$ export INITDB_EMAIL=admin
$ export INITDB_PASSWORD=admin
$ export INITDB_USERNAME=admin
$ export INITDB_ROLE=Admin
$ export DRUID_HOST=druid.master.in.rilldata.io
$ export DRUID_LOGIN_USER=airflow@rilldata.com
$ export DRUID_PASSWORD=xxxxxxxx
```
_note: wait for couple of minutes for scheduler to comes up_
```
$ make connections
```

### Step 3: Airflow Web Login
_note: wait for couple of minutes for webserver to comes up_
**Airflow Login**
```
http://localhost:8080
```

**Development Login**
```
username	: admin
password	: admin
```

## Clean Setup

```
$ make clean
```

## flower web uri

```
http://localhost:5555
```
