```mermaid
flowchart TD
    A["Generate New Geometry Parameters<br/>(gpOpt\\_TBL.nextGPsample())"]
    B["Update Geometry Configuration<br/>(main\\_pre.write_yTopParams())"]
    C["Run CFD Simulation<br/>(blockMesh, decomposePar, bash OFrun.sh)"]
    D["Post-process Simulation Data<br/>(OFpost.main())"]
    E["Update BO Model & Check Convergence<br/>(gpOpt\\_TBL.BO_update_convergence())"]
    F["Finalize & Backup Results<br/>(Backup using cp commands)"]

    A --> B
    B --> C
    C --> D
    D --> E
    E --> F
