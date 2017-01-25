#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool


hints:
- $import: envvar-global.yml
- $import: GATK-docker.yml

inputs:
  multithreading_nt:
    type: int
    default: 4
    inputBinding:
      position: 12
      prefix: -nt
    doc: multithreading option
  
  raw_vcf:
    type: File
    inputBinding:
      position: 5
      prefix: -input
    doc: input vcf File raw variant calls from haplotype caller

  reference:
    type: File
    secondaryFiles:
      - .fai
      - ^.dict
    inputBinding:
      position: 6
      prefix: -R
    doc: reference genome

  recal_file:
    type: File
    inputBinding:
      position: 7
      prefix: -recalFile
    doc: the recal file generated by VariantRecalibrator

  tranches_file:
    type: File
    inputBinding:
      position: 8
      prefix: -tranchesFile
    doc: the tranches file generated by VariantRecalibrator

  mode:
    type: string
    default: "SNP"
    inputBinding:
      position: 11
      prefix: -mode
    doc: specify if VQSR is called on SNPs or Indels

  ts_filter_level:
    type: float
    default: 99.9
    inputBinding:
      position: 10
      prefix: --ts_filter_level
    doc: filtering level default value is 99.9



  java_mem:
    type: string
    default: -Xmx8g
    inputBinding:
      position: 1

  java_tmp:
    type: string
    default: -Djava.io.tmpdir=/tmp
    inputBinding:
      position: 2

outputs:
  vqsr_vcf:
    type: File
    outputBinding:
      glob: vqsr.vcf
    doc: The output recalibration VCF file


arguments:
 - valueFrom: ./test/test-files
   position: 2
   separate: false
   prefix: -Djava.io.tmpdir=
 - valueFrom: /usr/local/bin/GenomeAnalysisTK.jar
   position: 3
   prefix: -jar
 - valueFrom: ApplyRecalibration
   position: 4
   prefix: -T
 - valueFrom: vqsr.vcf
   position: 9
   prefix: -o
baseCommand: [java]

