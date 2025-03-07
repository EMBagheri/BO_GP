```mermaid
flowchart TD
    A[Generate New Geometry Parameters<br/>(gpOpt_TBL.nextGPsample())]
    B[Update Geometry Configuration<br/>(main_pre.write_yTopParams())]
    C[Run CFD Simulation<br/>(blockMesh, decomposePar, bash OFrun.sh)]
    D[Post-process Simulation Data<br/>(OFpost.main())]
    E[Update BO Model & Check Convergence<br/>(gpOpt_TBL.BO_update_convergence())]
    F[Finalize & Backup Results<br/>(Backup using cp commands)]
    
    A --> B
    B --> C
    C --> D
    D --> E
    E --> F

### Explanation

- The file begins with three backticks followed by the word `mermaid` (i.e., ```mermaid) on a line by itself.
- After your Mermaid code, close the block with three backticks on a separate line.
- Save this as a `.md` file (for example, `flowchart.md`), and if your GitHub repository supports Mermaid (or if you use an online Mermaid editor), it will render the flowchart accordingly.

You can now commit this file to GitHub, and if Mermaid is supported, the flowchart will display correctly.
