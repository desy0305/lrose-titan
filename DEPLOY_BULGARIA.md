# TITAN Bulgaria - 7-Radar National Deployment

Storm identification, tracking and nowcasting across all of Bulgaria
using the full NIMH / Hail Suppression Agency radar network.

## Radar Network

| ID  | Location                  | Lat     | Lon     | Band | Alt   |
|-----|---------------------------|---------|---------|------|-------|
| JAR | Yarlovo (Sofia)           | 42.47°N | 23.58°E | S    | 1560m |
| BRD | Bardarski Geran (Vratsa)  | 43.55°N | 23.95°E | S    | 160m  |
| DCE | Dolno Tserovene (Montana) | 43.59°N | 23.25°E | S    | 140m  |
| GCD | Golyam Chardak (Plovdiv)  | 42.17°N | 24.78°E | S    | 250m  |
| POP | Popovitsa (Plovdiv)       | 42.14°N | 25.06°E | S    | 150m  |
| SMN | Shumen                    | 43.27°N | 26.92°E | S    | 180m  |
| STS | Staro Selo (Sliven)       | 42.58°N | 26.15°E | S    | 200m  |

All radars: MRL-5 IRIS/Vaisala, S-band (10cm), 4-minute scan cycle.
Data format: ODIM HDF5.

## Data Pipeline

```
ODIM HDF5 files
    └─> RadxConvert (x7)   → CfRadial per radar
        └─> Radx2Grid (x7) → MDV Cartesian per radar (460x460 km, 1km res)
            └─> MdvMerge2  → National mosaic (lat/lon, ~1km, covers all Bulgaria)
                └─> Titan  → Storm ID + tracking + nowcasting
```

## Prerequisites

- Docker Desktop running on Windows
- VNC viewer (e.g. [RealVNC Viewer](https://www.realvnc.com/en/connect/download/viewer/))

## Build & Run

```bash
cd lrose-titan
docker-compose up --build
```

First build: ~30-60 min (compiles lrose-core from source).
Subsequent starts: fast.

## Connect to Display

Open VNC viewer → connect to `localhost:5900` (no password).

You'll see the CIDD display with 4 zoom levels:
- BULGARIA_NATIONAL — full country view
- WEST_BULGARIA / EAST_BULGARIA — regional views
- SOFIA_REGION — local view

## Feeding Radar Data

Drop ODIM HDF5 files into the appropriate directory per radar:

```
/data/titan/raw/radar/jar/   ← Yarlovo (Sofia)
/data/titan/raw/radar/brd/   ← Bardarski Geran (Vratsa)
/data/titan/raw/radar/dce/   ← Dolno Tserovene (Montana)
/data/titan/raw/radar/gcd/   ← Golyam Chardak (Plovdiv)
/data/titan/raw/radar/pop/   ← Popovitsa (Plovdiv)
/data/titan/raw/radar/smn/   ← Shumen
/data/titan/raw/radar/sts/   ← Staro Selo (Sliven)
```

RadxConvert watches these directories and processes files automatically.

### Manual conversion (test a single file)

```bash
docker exec -it titan-bulgaria bash -c "
  radar_name=jar RADAR_NAME=JAR \
  RadxConvert -params /opt/titan/projDir/ingest/params/RadxConvert.bulgaria \
    -f /data/titan/raw/radar/jar/your_file.h5
"
```

## Mosaic is Fault-Tolerant

`is_required = FALSE` for all radars in MdvMerge2 — the mosaic will
be produced even if some radars are offline or not yet connected.

## Stop

```bash
docker-compose down
```

Data persists in the `titan-data` Docker volume between restarts.
