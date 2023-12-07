from rotd_py.fragment.nonlinear import Nonlinear
from rotd_py.system import Surface
from rotd_py.new_multi import Multi
from rotd_py.sample.multi_sample import MultiSample
from rotd_py.flux.fluxbase import FluxBase
from ase.atoms import Atoms

import numpy as np

def generate_grid(start, interval, factor, num_point):
    """Return a grid needed for the simulation of length equal to num_point

    @param start:
    @param interval:
    @param factor:
    @param num_point:
    @return:
    """
    i = 1
    grid = [start]
    for i in range(1, num_point):
        start += interval
        grid.append(start)
        interval = interval * factor
    return np.array(grid)


# temperature, energy grid and angular momentum grid
temperature = generate_grid(10, 10, 1.05, 51)
energy = generate_grid(0, 10, 1.05, 169)
angular_mom = generate_grid(0, 1, 1.1, 40)

# fragment info
{Fragments_block}

# Setting the dividing surfaces

{Surfaces_block}

{calc_block}

{scan_ref}
{scan_trust}
{scan_sample}

inf_energy = {inf_energy}

_{job_name} = MultiSample(fragments={frag_names}, inf_energy=inf_energy,
                         energy_size=1, min_fragments_distance={min_dist},
                         r_sample=r_sample, e_sample=e_sample,
                         r_trust=r_trust, e_trust=e_trust, scan_ref=scan_ref,
                         name='_{job_name}')

# the flux info per surface
#flux_rel_err: flux accuracy (1=99% certitude, 2=98%, ...)
#pot_smp_max: maximum number of sampling for each facet
#pot_smp_min: minimum number of sampling for each facet
#tot_smp_max: maximum number of total sampling
#tot_smp_min: minimum number of total sampling

{flux_block}

flux_base = FluxBase(temp_grid=temperature,
                     energy_grid=energy,
                     angular_grid=angular_mom,
                     flux_type='EJ-RESOLVED',
                     flux_parameter=flux_parameter)

# start the final run
# Will read from the restart db
multi = Multi(sample=_{job_name}, dividing_surfaces=divid_surf,
              fluxbase=flux_base, calculator=calc)
multi.run()

