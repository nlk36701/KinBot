#! /bin/bash

#SBATCH -N 1
#SBATCH -c {ppn}
#SBATCH -q {queue_name}
#SBATCH -o {errdir}/{name}.stdout
#SBATCH -e {errdir}/{name}.err
#SBATCH --mem=10gb
