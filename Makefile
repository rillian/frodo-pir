# DB location values
DB_FILE_NAME=rand_db.json
DB_FILE_PATH=data/${DB_FILE_NAME}
PARAMS_OUTPUT_PATH=data/params.json
PREVIOUS_DIR=..

# cargo build values
MATRIX_HEIGHT_EXP=16
LWE_DIMENSION=1572
ELEMENT_SIZE_EXP=13
PLAINTEXT_SIZE_EXP=10
NUM_SHARDS=8

# rust flags 
RUST_BACKTRACE=1

# python db generation values
DB_ALL_ONES=0
DB_NUM_ENTRIES_EXP=${MATRIX_HEIGHT_EXP}

RUST_FLAGS=RUST_BACKTRACE=${RUST_BACKTRACE}
DB_ENV=DB_FILE=${PREVIOUS_DIR}/${DB_FILE_PATH} PARAMS_OUTPUT_PATH=${PREVIOUS_DIR}/${PARAMS_OUTPUT_PATH}
PRELIM=${RUST_FLAGS} ${DB_ENV}
PIR_FLAGS=-m ${MATRIX_HEIGHT_EXP} --dim ${LWE_DIMENSION} --ele_size ${ELEMENT_SIZE_EXP} --plaintext_bits ${PLAINTEXT_SIZE_EXP} --num_shards ${NUM_SHARDS}
PIR_ENV=PIR_MATRIX_HEIGHT_EXP=${MATRIX_HEIGHT_EXP} PIR_LWE_DIM=${LWE_DIMENSION} PIR_ELE_SIZE_EXP=${ELEMENT_SIZE_EXP} PIR_PLAINTEXT_BITS=${PLAINTEXT_SIZE_EXP} PIR_NUM_SHARDS=${NUM_SHARDS}
PIR_ENV_ALL=PIR_LWE_DIM=${LWE_DIMENSION} PIR_ELE_SIZE_EXP=${ELEMENT_SIZE_EXP} PIR_NUM_SHARDS=${NUM_SHARDS}
DB_GEN_PRELIM=DB_ALL_ONES=${DB_ALL_ONES} DB_NUM_ENTRIES_EXP=${DB_NUM_ENTRIES_EXP} DB_OUTPUT_PATH=${DB_FILE_PATH} DB_ELEMENT_SIZE_EXP=${ELEMENT_SIZE_EXP}

LIB_PRELIM=${DB_FILE_PRELIM}
BIN_PRELIM=${BIN_DB_FILE_PRELIM} ${PARAMS_OUTPUT_PATH_PRELIM}

CARGO=cargo
CARGO_COMMAND=${PRELIM} ${CARGO}
PYTHON_COMMAND=${DB_GEN_PRELIM} python3

.PHONY: gen-db
gen-db:
	${PYTHON_COMMAND} data/generate_db.py

.PHONY: build test bench bench-all
build:
	${CARGO_COMMAND} build
test:
	${CARGO_COMMAND} test
bench:
	${PRELIM} ${PIR_ENV} ${CARGO} bench
bench-all:
	${PRELIM} ${PIR_ENV_ALL} PIR_MATRIX_HEIGHT_EXP=16 PIR_PLAINTEXT_BITS=10 ${CARGO} bench > benchmarks-16.txt
	${PRELIM} ${PIR_ENV_ALL} PIR_MATRIX_HEIGHT_EXP=17 PIR_PLAINTEXT_BITS=10 ${CARGO} bench > benchmarks-17.txt
	${PRELIM} ${PIR_ENV_ALL} PIR_MATRIX_HEIGHT_EXP=18 PIR_PLAINTEXT_BITS=10 ${CARGO} bench > benchmarks-18.txt
	${PRELIM} ${PIR_ENV_ALL} PIR_MATRIX_HEIGHT_EXP=19 PIR_PLAINTEXT_BITS=9 ${CARGO} bench > benchmarks-19.txt
	${PRELIM} ${PIR_ENV_ALL} PIR_MATRIX_HEIGHT_EXP=20 PIR_PLAINTEXT_BITS=9 ${CARGO} bench > benchmarks-20.txt
