#!/usr/bin/env bash
# run_sim.sh -- Script per compilar, elaborar i simular un testbench VHDL amb GHDL i obrir GTKWave
# Ús:
#   ./run_sim.sh [SIM_DIR] [TB_ENTITY]
#   - SIM_DIR : directori on estan els .vhdl (per defecte: directori actual)
#   - TB_ENTITY : (opcional) nom de l'entitat del testbench (per ex. tb_kk). Si no es passa,
#                 el script intentarà trobar un fitxer tb_*.vhdl i extreure l'entitat.
#
# Exemple:
#   ./run_sim.sh /home/adria/Documents/Hw/cosa_pel_github/simulation tb_kk
#
set -euo pipefail

echo "=== run_sim.sh: iniciant ==="

# directori de treball (podeu passar-lo com 1er argument)
SIM_DIR="${1:-$(pwd)}"
echo "Directori de simulació: $SIM_DIR"
cd "$SIM_DIR"

# recollir fitxers .vhdl
shopt -s nullglob
VHDL_FILES=( *.vhdl )
if [ ${#VHDL_FILES[@]} -eq 0 ]; then
    echo "No s'han trobat fitxers .vhdl a $SIM_DIR"
    exit 1
fi
echo "Fitxers VHDL trobats: ${VHDL_FILES[*]}"

# detectar nom del testbench (TB_ENTITY)
TB_ENTITY="${2:-}"
if [ -z "$TB_ENTITY" ]; then
    # primer, busca un fitxer tb_*.vhdl
    TB_FILE=""
    for f in "${VHDL_FILES[@]}"; do
        case "$(basename "$f")" in
            tb.vhdl) TB_FILE="$f"; break;;
        esac
    done

    # si no hi ha tb_*.vhdl, prova a trobar un fitxer que contingui una entitat amb prefix "tb"
    if [ -z "$TB_FILE" ]; then
        for f in "${VHDL_FILES[@]}"; do
            if grep -qiE 'entity[[:space:]]+tb' "$f"; then
                TB_FILE="$f"; break
            fi
        done
    fi

    # extreure el nom de l'entitat del fitxer TB_FILE
    if [ -n "${TB_FILE}" ]; then
        TB_ENTITY=$(grep -i -m1 'entity' "$TB_FILE" | sed -E 's/.*entity[[:space:]]+([a-zA-Z0-9_]+).*/\1/i' || true)
        echo "Detectat fitxer testbench: $TB_FILE  -> entitat: $TB_ENTITY"
    fi
fi

if [ -z "$TB_ENTITY" ]; then
    echo ""
    echo "No s'ha pogut detectar automàticament el nom de l'entitat del testbench."
    echo "Passa el nom com a segon argument: ./run_sim.sh [SIM_DIR] TB_ENTITY"
    echo "Ex: ./run_sim.sh . tb_kk"
    exit 2
fi

# fitxer d'ones, per defecte
OUT_GHW="run.ghw"

echo "1) Analitzant fitxers VHDL amb GHDL..."
ghdl -a --ieee=synopsys -fexplicit "${VHDL_FILES[@]}"

echo "2) Elaborant el testbench ($TB_ENTITY)..."
ghdl -e --ieee=synopsys -fexplicit "$TB_ENTITY"

echo "3) Executant la simulació i generant ondes a $OUT_GHW..."
# afegeixo un stop-time per evitar simulacions infinites per error: 200ns per defecte
ghdl -r --ieee=synopsys -fexplicit "$TB_ENTITY" --wave="$OUT_GHW" --stop-time=200ns

echo "Simulació acabada. Fitxer d'onades: $SIM_DIR/$OUT_GHW"

# obrir GTKWave si està instal·lat
if command -v gtkwave >/dev/null 2>&1; then
    echo "Obrint GTKWave..."
    gtkwave "$OUT_GHW" &
else
    echo "GTKWave no trobat al PATH. Pots obrir manualment: gtkwave $OUT_GHW"
fi

echo "=== run_sim.sh: finalitzat ==="
