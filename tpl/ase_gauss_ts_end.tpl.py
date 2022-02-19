import numpy as np
import ase
from ase import Atoms
from ase.calculators.gaussian import Gaussian
from ase.db import connect
from kinbot import reader_gauss

db = connect('{working_dir}/kinbot.db')

atom = {atom}
geom = {geom}
dummy = None
mol = Atoms(symbols=atom, positions=geom)

kwargs = {kwargs}
Gaussian.command = '{qc_command} < PREFIX.com > PREFIX.log'
calc = Gaussian(**kwargs)
mol.set_calculator(calc)

try:
    e = mol.get_potential_energy() # use the Gaussian optimizer
    mol.positions = read_geom('{label}.log', mol, dummy)
    freq = reader_gauss.read_freq('{label}.log', {atom})
    zpe = reader_gauss.read_zpe('{label}.log')
    db.write(mol, name='{label}', data={{'energy': e,'frequencies': np.asarray(freq), 'zpe':zpe, 'status': 'normal'}})
except RuntimeError: 
    try:
        mol.positions = read_geom('{label}.log', mol, dummy)
        e = mol.get_potential_energy() # use the Gaussian optimizer
        mol.positions = read_geom('{label}.log', mol, dummy)
        freq = reader_gauss.read_freq('{label}.log', {atom})
        zpe = reader_gauss.read_zpe('{label}.log')
        db.write(mol, name='{label}', data={{'energy': e,'frequencies': np.asarray(freq), 'zpe':zpe, 'status': 'normal'}})
    except:
        db.write(mol, name='{label}', data = {{'status': 'error'}})

with open(f'{label}.log','a') as f:
    f.write('done\n')
