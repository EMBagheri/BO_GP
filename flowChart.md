```mermaid
flowchart TD
    A[Generate New Geometry Parameters\n(gpOpt_TBL.nextGPsample())]
    B[Update Geometry Configuration\n(main_pre.write_yTopParams())]
    C[Run CFD Simulation\n(blockMesh, decomposePar, bash OFrun.sh)]
    D[Post-process Simulation Data\n(OFpost.main())]
    E[Update BO Model & Check Convergence\n(gpOpt_TBL.BO_update_convergence())]
    F[Finalize & Backup Results\n(Backup using cp commands)]
    
    A --> B
    B --> C
    C --> D
    D --> E
    E --> F
