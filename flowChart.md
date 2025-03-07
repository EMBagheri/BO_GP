```mermaid
flowchart TD
    subgraph Initialization
      A1["Driver_BOGP.py: Set simulation & optimization settings"]
      A2["Define paths: OFcase, OFpre, OFpost, gpOptim, figs, data, storage"]
      A3["Load initial parameters from gpOptim/gpOpt.py & driver_BOGP_example.py"]
      A1 --> A2
      A2 --> A3
    end

    subgraph Preprocessing
      B1["OFpre/main_pre.py: Write yTopParams.in using new sample\n(new geometry parameters)"]
      B2["inflow/inflow_gen.py: Create inflow conditions (if needed)"]
      B3["Update blockMeshDict with new geometry parameters"]
      A3 --> B1
      B1 --> B2
      B2 --> B3
    end

    subgraph Simulation
      C1["OFcase/system: Mesh generation\n(blockMesh & decomposePar)"]
      C2["Run simulation via OFrun.sh (jobscript)"]
      B3 --> C1
      C1 --> C2
    end

    subgraph PostProcessing
      D1["OFpost/main_post.py: Post-process simulation results"]
      D2["Compute boundary layer parameters\n(β, Reₜ, δ*, etc.) & objective"]
      D3["Save figures (figs/) and data (data/)"]
      C2 --> D1
      D1 --> D2
      D2 --> D3
    end

    subgraph Optimization_Update
      E1["gpOptim/gpOpt.py: Update gpList.dat\n(append sample & objective)"]
      E2["Check convergence criteria\n(BO_update_convergence())"]
      D3 --> E1
      E1 --> E2
      E2 -- "Not Converged" --> B1
    end

    subgraph Backup
      F1["Backup simulation results to storage/"]
      F2["Copy figs, data, gpList.dat, logs to backup directory"]
      E2 -- "Converged" --> F1
      F1 --> F2
    end

