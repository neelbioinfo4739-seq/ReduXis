ReduXis
============
<p align="center">
	<img src="https://github.com/user-attachments/assets/7564d002-cd05-4516-ab74-4483cba5524a" alt="ReduXis Logo" width="500"/>
</p>

**Redu**ced-dimensional **X**-modality **I**ntegrated **S**tage and Subtype Inference, or ReduXis, is a lightweight and powerful
preprocessing and wrapper framework built atop the s-SuStaIn (scaled Subtype and Stage Inference) event-based model for
disease progression, designed to enhance the scalability, usability, interpretability, and reproducibility of supervised 
staging/subtyping analyses on noisy, high-dimensional biological data.

In complex biomedical datasets, direct application of probabilistic progression models is often limited by dimensionality, 
heterogeneous preprocessing needs, and opaque output formatting. ReduXis addresses these challenges through a modular interface 
that automates ensemble-based feature selection, performs standardized preprocessing, and produces interpretable outputs, including
stage/subtype assignments in human-readable formats (e.g., TSV) and visual summaries such as biomarker heatmaps and stage 
distributions.

The framework is particularly tailored for monotonic biological processes, where disease severity progresses without reversal, and 
has demonstrated generalizability across diseases such as Alzheimer's disease (AD), as well as several different types of cancer
(colorectal adenocarcinoma, urothelial carcinoma). Additionally, event-based models similar to s-SuStaIn have also been applied to
Parkinson’s disease, Huntington’s disease, and Type 1 diabetes.

Key features include:
1. An interactive command-line interface (CLI) with intelligent prompts for key parameters and file inputs (data and metadata).

2. Ensemble voting-based feature selection, allowing users to downselect from thousands of raw features (e.g., genes) to the
most discriminative biomarkers (default: 100), balancing predictive performance with computational efficiency.

3. Supervised modeling interface that requires a disease outcome label and does not support unsupervised inference, ensuring
clinical relevance and robust validation.

4. Model visualization tools, including:

	A) Expression heatmaps by subtype

	B) Biomarker stage assignment matrices

	C) Inferred stage distributions stratified by clinical outcome across subtypes

5. Output designed for downstream analysis, publication, and cross-cohort validation, in legible tabular format.

6. A chi-squared goodness of fit tests designed for statistical analysis, quantifying whether or not the s-SuStaIn event-based
model that ReduXis uses is inferring stages across outcome randomly, or if instead the model uses key features when assigning 
stages to a particular subject.

Installation
=============

Clone this repository and install it locally.

`git clone https://github.com/pathology-dynamics/ReduXis.git`

`cd ReduXis`

`pip install .`

Alternatively, for an *editable* install, use this:

`pip install -e .`

This will install everything listed in `pyproject.toml`, including the `awkde` package, which is used for mixture modelling. 

Please note that you need Python version 3.11+ for this installation to work. If installation fails, please make sure to create
a new environment. To do this, follow the instructions in the Troubleshooting section below.

Troubleshooting
================
If the installation does not work, you could either have packages that are installed that conflict with the requirements,
or an old version of Python installed locally.you may have some interfering packages installed. One way around this would be to 
create a new [Anaconda](https://docs.conda.io/projects/conda/en/stable/) environment that uses Python 3.11+, then activate it and repeat 
the installation steps above. To do this, download and install Anaconda/Miniconda, then run:

`conda create -n sustain_env python==3.11`
`conda activate sustain_env`

This will create an environment named `sustain_env`. Afterwards, follow the installation instructions as detailed in the previous section.

Dependencies
=============
- [Python >= 3.11](https://github.com/python/cpython)
- [NumPy >= 2.2](https://github.com/numpy/numpy)
- [Pandas](https://github.com/pandas-dev/pandas)
- [Scipy](https://github.com/scipy/scipy)
- [Matplotlib](https://github.com/matplotlib/matplotlib)
- [Seaborn](https://github.com/mwaskom/seaborn)
- [LightGBM](https://github.com/microsoft/LightGBM) for ensemble voting-based feature selection
- [colorama](https://github.com/tartley/colorama) for colorful display screen for help
- [scikit-learn](https://github.com/scikit-learn/scikit-learn) for classification and report generation
- [imbalanced-learn](https://github.com/scikit-learn-contrib/imbalanced-learn) for oversampling on class-imbalanced data
- [kde_ebm](https://github.com/ucl-pond/kde_ebm) for mixture modeling (KDE and GMM included)
- [pathos](https://github.com/uqfoundation/pathos) for parallelization
- [awkde](https://github.com/noxtoby/awkde) for KDE mixture modeling

Testing
========
In order to check that the installation was successful, navigate to the `tests` subfolder in wherever ReduXis is installed. First, run
`create_validation.py` in order to initialize the mixture arrays and objects that `validation.py` depends on:

`python3 create_validation.py`

Then, use the following command to run all SuStaIn variants (this may take a lot of time depending on CPU performance):

`python3 validation.py -f`

For a quicker run (using just `MixtureSustain`), just use:

`python3 validation.py`

Additionally, in order to test for cross validation on the base SuStaIn algorithm, just run:

`python3 simrun.py`

Demo
=====
This demo showcases ReduXis using RNA-Seq data from The Cancer Genome Atlas (TCGA) for Colorectal Adenocarcinoma (COAD).
Example data (dbGaP accession: phs000178) were processed in accordance with TCGA best practices and is pre-packaged and randomized for 
standardization and reproducibility. For more information, see the [TCGA COAD project page](https://www.ncbi.nlm.nih.gov/projects/gap/cgi-bin/study.cgi?study_id=phs000178).

To execute the demo:

1. From the root directory, launch ReduXis:

`reduxis`

2. When prompted for file inputs, provide the following:

`data/TPM RNA Gene Counts.tsv`

`data/Outcome Metadata.tsv`

3. Follow the interactive CLI prompts to preprocess the data and perform subtype/stage inference using the s-SuStaIn engine, such as the name
of the dataset (e.g. 'Sample_Data'), number of stages, number of subtypes, enabling parallelization, and whether or not to perform sensitivity
analysis on the minimum stability score for feature selection.

A successful run will generate:

- Visualizations: biomarker heatmaps, subtype-specific biomarker trajectories, 

- Outputs: tabular TSV results and a chi squared goodness of fit stratification report to determine statistical significance of the inferred stages

For detailed visual demonstrations of ReduXis in practice, please refer to the User Guide section below. The platform includes two example datasets, 
arranged by increasing complexity, to guide users through its functionality and analytical capabilities. These datasets include synthetic as well as 
quasi-real-world transcriptomic data.

1. Test Case 1 – Simulated Dataset (Validation):
This initial test case utilizes a fully synthetic dataset, found in the `simrun.py` script within the `tests` subdirectory, designed to validate the underlying modeling approach of ReduXis. The dataset comprises 800 simulated subjects, each characterized by 5 biomarkers, and grouped into 4 distinct disease subtypes. To ensure robust assessment of model generalizability and performance, 3-fold cross-validation is employed. Importantly, this test case uses the pySuStaIn implementation rather than s-SuStaIn, due to its suitability for controlled synthetic data and its alignment with the validation framework. While s-SuStaIn is not directly applied here, successful modeling using pySuStaIn serves as a proof-of-concept for ReduXis, as both tools share conceptual and algorithmic foundations. Performance on this dataset establishes baseline functionality and confirms that ReduXis is capable of capturing subtype progression patterns—thereby justifying its application to more complex, real-world datasets.

2. Test Case 2 – Noisy TCGA-COAD (Colorectal Adenocarcinoma):
This dataset is the same randomized, de-identified version TCGA-COAD data used in the demo. It is intended as the simplest biologically-valid use case,
containing two clinical outcome classes and an expected single developmental trajectory. Synthetic Gaussian noise was injected into this dataset in order
to protect the medical data of the original subjects.

User Guide
============

ReduXis provides an interactive command-line interface (CLI) that guides users through every required input and configuration.

To launch the CLI help menu:
`reduxis -h` or `reduxis --help`

This will provide a list of  key inputs such as data matrices, metadata, outcome labels, and modeling parameters, as illustrated below:

<img width="3932" height="4859" alt="ReduXis Welcome Screen" src="https://github.com/user-attachments/assets/39c15fbb-518b-4112-9267-cb8a525d1197" />

Additionally, here is an example of a successful ReduXis run, showing how the framework processes a binary-class test case with ease and elegance.
In this scenario, the user is using colorectal adenocarcinoma as their disease of choice, with data labeled as `Normal` or `Tumor` to indicate that
a particular tissue sample is either healthy or cancerous, respectively.

https://github.com/user-attachments/assets/427e6b77-2510-4031-9465-7b0b8170f2e8

Acknowledgements
================
If you use ReduXis and the example data associated with ReduXis, please cite the following core papers:
1. [SuStaIn: An algorithm uncovering the complexity of neurodegenerative disease progression](https://doi.org/10.1038/s41467-018-05892-0)
2. [pySuStaIn: A Python implementation of SuStaIn](https://doi.org/10.1016/j.softx.2021.100811)
3. [s-SuStaIn: A scaled version of pySuStaIn](https://pmc.ncbi.nlm.nih.gov/articles/PMC11881980)
4. [ReduXis: A generalizable, user-friendly wrapper of s-SuStaIn](https://doi.org/10.3390/ijms26188973)
5. [TCGA COAD: A comprehensive molecular characterization of human colon and rectal cancer](https://doi.org/10.1038/nature11252)
6. [TCGA BLCA: An extensive molecular characterization of urothelial carcinoma](https://doi.org/10.1038/nature12965)
7. [EHBS: An innovative, longtitudinal study involving healthy middle-aged to older adults in preventing Alzheimer's disease progression through early treatment](https://doi.org/10.1159/000501856)

Please also cite the corresponding progression pattern model you use:
1. [The event-based model (i.e. MixtureSustain)](https://doi.org/10.1016/j.neuroimage.2012.01.062)
   with [Gaussian mixture modelling](https://doi.org/10.1093/brain/awu176)
   or [kernel density estimation](https://doi.org/10.1002/alz.12083).
2. [The piecewise linear Z-score event-based model (i.e. ZscoreSustain)](https://doi.org/10.3389/frai.2021.613261)
3. [The scored event-based model (i.e. OrdinalSustain)](https://doi.org/10.3389/frai.2021.613261)

Additionally, please take a closer look at these papers for more information about the broader applications of event-based models:
1. [Temporal event-based model (TEBM) models Huntington's disease progression](https://doi.org/10.1162/imag_a_00010)
2. [Kernel density estimation event-based model (KDE EBM) predicts clinical and neurodegeneration events in Parkinson's disease](https://doi.org/10.1093/brain/awaa461)
3. [Continuous time-hidden Markov model (CT-HMM) produces distinct autoantibody trajectories in Type 1 diabetes progression](https://doi.org/10.1038/s41467-022-28909-1)
4. [Scaled cross-sectional event based model (sEBM) stratifies risk of Alzheimer’s disease in healthy middle-aged adults](https://doi.org/10.1093/braincomms/fcaf121)

Funding
========
This project was supported by National Institute of Health grants R01 AG070937 and R35GM152245 (CSM), as well as subawards from U19 AG056169. 
Additional funding was provided by the National Science Foundation award 1944247, and the Chan Zuckerberg Initiative grant 253558.
