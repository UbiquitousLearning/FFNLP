# conda activate ptpretrain

# agnews 100
# bash run_fed.sh agnews fedpet 7 100 -1 -1
# bash run_fed.sh agnews fedclassifier 7 100 -1 -1

# mnli 100
# bash run_fed.sh mnli fedpet 7 100 8700 392700
# bash run_fed.sh mnli fedclassifier 7 100 8700 392700

# yahoo 100
# bash run_fed.sh yahoo fedpet 1 100 -1 -1
# bash run_fed.sh yahoo fedclassifier 1 100 -1 -1

# yelp-full 40
# bash run_fed.sh yelp-full fedpet 1 40 -1 -1
# bash run_fed.sh yelp-full fedclassifier 1 40 -1 -1



output_dir="/data2/cdq/pet_data"
data_dir="${output_dir}/data"

dataset=$1 # agnews, mnli, yahoo, yelp-full
method=$2 # fedpet, fedclassifer
device=$3
train_examples=$4 # done: 40; todo: 10, 100, 1000, 
test_examples=$5 # 8700 for mnli
unlabeled_examples=$6 # 392700 for mnli
beta=$7 # niid button, 0 for off.
client_num_in_total=$8

task_name=${dataset}
model_type="bert"
model_name_or_path="bert-base-uncased"

pattern_ids=1
epochs=10
iteration=100
clients=${client_num_in_total}

mkdir -p /${output_dir}/log/${dataset}/
mkdir -p ./log/${dataset}

if [ $beta == 0 ]; then
    if [ $method == "fedpet" ]; then
        echo "fedpet start."
        CUDA_VISIBLE_DEVICES=$device python3 cli.py \
        --train_examples ${train_examples} \
        --test_examples ${test_examples} \
        --unlabeled_examples ${unlabeled_examples} \
        --method ${method} \
        --pattern_ids ${pattern_ids} \
        --data_dir $data_dir/${dataset} \
        --model_type ${model_type} \
        --model_name_or_path ${model_name_or_path} \
        --task_name ${task_name} \
        --output_dir /${output_dir}/log/${dataset}/${method}_${train_examples}_${clients} \
        --ipet_scale_factor 1 \
        --ipet_generations ${iteration} \
        --pet_num_train_epochs ${epochs} \
        --pet_repetitions 1 \
        --pet_per_gpu_train_batch_size 4 \
        --sc_num_train_epochs ${epochs} \
        --sc_repetitions ${iteration} \
        --client_num_in_total ${client_num_in_total} \
        --do_train \
        --do_eval \
        --vanilla \
        --no_cuda > log/${dataset}/${method}_${train_examples}_${clients}.log 2>&1
    else
        echo "fedcls start."
        CUDA_VISIBLE_DEVICES=$device python3 cli.py \
        --train_examples ${train_examples} \
        --test_examples ${test_examples} \
        --unlabeled_examples ${unlabeled_examples} \
        --method ${method} \
        --pattern_ids ${pattern_ids} \
        --data_dir $data_dir/${dataset} \
        --model_type ${model_type} \
        --model_name_or_path ${model_name_or_path} \
        --task_name ${task_name} \
        --output_dir /${output_dir}/log/${dataset}/${method}_${train_examples}_${clients} \
        --ipet_scale_factor 1 \
        --ipet_generations ${iteration} \
        --pet_num_train_epochs ${epochs} \
        --pet_repetitions 1 \
        --pet_per_gpu_train_batch_size 4 \
        --sc_num_train_epochs ${epochs} \
        --sc_repetitions ${iteration} \
        --client_num_in_total ${client_num_in_total} \
        --do_train \
        --do_eval \
        --vanilla \
        --no_cuda > log/${dataset}/${method}_${train_examples}_${clients}.log 2>&1
    fi
else
    if [ $method == "fedpet" ]; then
        echo "fedpet start."
        CUDA_VISIBLE_DEVICES=$device python3 cli.py \
        --train_examples ${train_examples} \
        --test_examples ${test_examples} \
        --unlabeled_examples ${unlabeled_examples} \
        --method ${method} \
        --pattern_ids ${pattern_ids} \
        --data_dir $data_dir/${dataset} \
        --model_type ${model_type} \
        --model_name_or_path ${model_name_or_path} \
        --task_name ${task_name} \
        --output_dir /${output_dir}/log/${dataset}/${method}_${train_examples}_${clients}_${beta} \
        --ipet_scale_factor 1 \
        --ipet_generations ${iteration} \
        --pet_num_train_epochs ${epochs} \
        --pet_repetitions 1 \
        --pet_per_gpu_train_batch_size 4 \
        --sc_num_train_epochs ${epochs} \
        --sc_repetitions ${iteration} \
        --client_num_in_total ${client_num_in_total} \
        --beta ${beta} \
        --do_train \
        --do_eval \
        --vanilla \
        --no_cuda > log/${dataset}/${method}_${train_examples}_${clients}_${beta}.log 2>&1
    else
        echo "fedcls start."
        CUDA_VISIBLE_DEVICES=$device python3 cli.py \
        --train_examples ${train_examples} \
        --test_examples ${test_examples} \
        --unlabeled_examples ${unlabeled_examples} \
        --method ${method} \
        --pattern_ids ${pattern_ids} \
        --data_dir $data_dir/${dataset} \
        --model_type ${model_type} \
        --model_name_or_path ${model_name_or_path} \
        --task_name ${task_name} \
        --output_dir /${output_dir}/log/${dataset}/${method}_${train_examples}_${clients}_${beta} \
        --ipet_scale_factor 1 \
        --ipet_generations ${iteration} \
        --pet_num_train_epochs ${epochs} \
        --pet_repetitions 1 \
        --pet_per_gpu_train_batch_size 4 \
        --sc_num_train_epochs ${epochs} \
        --sc_repetitions ${iteration} \
        --client_num_in_total ${client_num_in_total} \
        --beta ${beta} \
        --do_train \
        --do_eval \
        --vanilla \
        --no_cuda > log/${dataset}/${method}_${train_examples}_${clients}_${beta}.log 2>&1
    fi
fi


# local pet
# conda activate ptpretrain && CUDA_VISIBLE_DEVICES=4 python3 cli.py --train_examples 40 --method fedpet --pattern_ids 1 --data_dir ./data/ --model_type bert --model_name_or_path bert-base-uncased --task_name agnews --output_dir /data/cdq/pet/log_local_pet_2_40_10 --ipet_scale_factor 2 --ipet_generations 100 --pet_num_train_epochs 10 --pet_repetitions 1 --pet_per_gpu_train_batch_size 4 --do_train --do_eval >> log_local_pet_2_40_10.log 2>&1

# # 1 sample for all clients
# # 10 Clients

# # Fedcls
# rm -rf /data/cdq/pet/log_fedcls_vanilla_10_10 
# conda activate ptpretrain && CUDA_VISIBLE_DEVICES=0 python3 cli.py --train_examples 10 --method fedclassifier --pattern_ids 1 --data_dir ./data/ --model_type bert --model_name_or_path bert-base-uncased --task_name agnews --output_dir /data/cdq/pet/log_fedcls_vanilla_10_10 --sc_num_train_epochs 10 --sc_repetitions 100 --do_train --do_eval > log_fedcls_vanilla_10_10.log 2>&1

# # Fed vanilla
# rm -rf /data/cdq/pet/log_fedpet_vanilla_10_10
# conda activate ptpretrain && CUDA_VISIBLE_DEVICES=1 python3 cli.py --train_examples 10 --method fedpet --pattern_ids 1 --data_dir ./data/ --model_type bert --model_name_or_path bert-base-uncased --task_name agnews --output_dir /data/cdq/pet/log_fedpet_vanilla_10_10 --ipet_scale_factor 1 --ipet_generations 100 --pet_num_train_epochs 10 --pet_repetitions 1 --pet_per_gpu_train_batch_size 4 --do_train --do_eval --vanilla --alpha 1 > log_fedpet_vanilla_10_10.log 2>&1 

# # fed prompt learning (should be the same as Fed vanilla)
# rm -rf /data/cdq/pet/log_fedpet_avg_10_10 
# conda activate ptpretrain && CUDA_VISIBLE_DEVICES=2 python3 cli.py --train_examples 10 --method fedpet --pattern_ids 1 --data_dir ./data/ --model_type bert --model_name_or_path bert-base-uncased --task_name agnews --output_dir /data/cdq/pet/log_fedpet_avg_10_10 --ipet_scale_factor 1 --ipet_generations 100 --pet_num_train_epochs 10 --pet_repetitions 1 --pet_per_gpu_train_batch_size 4 --do_train --do_eval --aggregated --fed  > log_fedpet_avg_10_10.log 2>&1 

# # fed prompt learning + soft label
# rm -rf /data/cdq/pet/log_fedpet_voting_avg_10_10 
# conda activate ptpretrain && CUDA_VISIBLE_DEVICES=3 python3 cli.py --train_examples 10 --method fedpet --pattern_ids 1 --data_dir ./data/ --model_type bert --model_name_or_path bert-base-uncased --task_name agnews --output_dir /data/cdq/pet/log_fedpet_voting_avg_10_10 --ipet_scale_factor 1 --ipet_generations 100 --pet_num_train_epochs 10 --pet_repetitions 1 --pet_per_gpu_train_batch_size 4 --do_train --do_eval --aggregated --fed --augmentation > log_fedpet_voting_avg_10_10.log 2>&1 


# # 4 sample for all clients
# # 10 Clients; Agnews; BERT; epoch 3; repetition 10000; Niid: beta=1

# # Fedcls niid
# rm -rf /data/cdq/pet/log_fedcls_vanilla_beta_1_40_10 
# conda activate ptpretrain && CUDA_VISIBLE_DEVICES=6 python3 cli.py --train_examples 40 --method fedclassifier --pattern_ids 1 --data_dir ./data/ --model_type bert --model_name_or_path bert-base-uncased --task_name agnews --output_dir /data/cdq/pet/log_fedcls_vanilla_beta_1_40_10 --sc_num_train_epochs 3 --sc_repetitions 1000 --do_train --do_eval --beta 1 > log_fedcls_vanilla_beta_1_40_10.log 2>&1

# # Fed vanilla
# rm -rf /data/cdq/pet/log_fedpet_vanilla_beta_1_40_10
# conda activate ptpretrain && CUDA_VISIBLE_DEVICES=6 python3 cli.py --train_examples 40 --method fedpet --pattern_ids 1 --data_dir ./data/ --model_type bert --model_name_or_path bert-base-uncased --task_name agnews --output_dir /data/cdq/pet/log_fedpet_vanilla_beta_1_40_10 --ipet_scale_factor 1 --ipet_generations 1000 --pet_num_train_epochs 3 --pet_repetitions 1 --pet_per_gpu_train_batch_size 4 --do_train --do_eval --vanilla --beta 1 > log_fedpet_vanilla_beta_1_40_10.log 2>&1 

# # fed prompt learning (should be the same as Fed vanilla)
# rm -rf /data/cdq/pet/log_fedpet_avg_beta_1_40_10 
# conda activate ptpretrain && CUDA_VISIBLE_DEVICES=1 python3 cli.py --train_examples 40 --method fedpet --pattern_ids 1 --data_dir ./data/ --model_type bert --model_name_or_path bert-base-uncased --task_name agnews --output_dir /data/cdq/pet/log_fedpet_avg_beta_1_40_10 --ipet_scale_factor 1 --ipet_generations 1000 --pet_num_train_epochs 3 --pet_repetitions 1 --pet_per_gpu_train_batch_size 4 --do_train --do_eval --aggregated --fed --beta 1 > log_fedpet_avg_beta_1_40_10.log 2>&1 

# # fed prompt learning + soft label
# rm -rf /data/cdq/pet/log_fedpet_voting_avg_beta_1_40_10 
# conda activate ptpretrain && CUDA_VISIBLE_DEVICES=6 python3 cli.py --train_examples 40 --method fedpet --pattern_ids 1 --data_dir ./data/ --model_type bert --model_name_or_path bert-base-uncased --task_name agnews --output_dir /data/cdq/pet/log_fedpet_voting_avg_10_10 --ipet_scale_factor 1 --ipet_generations 1000 --pet_num_train_epochs 3 --pet_repetitions 1 --pet_per_gpu_train_batch_size 4 --do_train --do_eval --aggregated --fed --augmentation --beta 1 > log_fedpet_voting_avg_beta_1_40_10.log 2>&1 


# old
# conda activate ptpretrain && CUDA_VISIBLE_DEVICES=4 python3 cli.py --train_examples 40 --method fedpet --pattern_ids 1 --data_dir ./data/ --model_type bert --model_name_or_path bert-base-uncased --task_name agnews --output_dir /data/cdq/pet/log_fedpet_voting_40_10 --ipet_scale_factor 5 --ipet_generations 100 --pet_num_train_epochs 10 --pet_repetitions 1 --pet_per_gpu_train_batch_size 4 --do_train --do_eval > log_fedpet_voting_40_10.log 2>&1

# conda activate ptpretrain && CUDA_VISIBLE_DEVICES=4 python3 cli.py --train_examples 40 --method fedpet --pattern_ids 1 --data_dir ./data/ --model_type bert --model_name_or_path bert-base-uncased --task_name agnews --output_dir /data/cdq/pet/log_fedpet_voting_avg_2_40_10 --ipet_scale_factor 5 --ipet_generations 100 --pet_num_train_epochs 10 --pet_repetitions 1 --pet_per_gpu_train_batch_size 4 --do_train --do_eval > log_fedpet_voting_avg_2_40_10.log 2>&1

# conda activate ptpretrain && CUDA_VISIBLE_DEVICES=2 python3 cli.py --train_examples 40 --method fedpet --pattern_ids 1 --data_dir ./data/ --model_type bert --model_name_or_path bert-base-uncased --task_name agnews --output_dir /data/cdq/pet/log_fedpet_voting_avg_3_40_10 --ipet_scale_factor 2 --ipet_generations 100 --pet_num_train_epochs 10 --pet_repetitions 1 --pet_per_gpu_train_batch_size 4 --do_train --do_eval > log_fedpet_voting_avg_3_40_10.log 2>&1

# conda activate ptpretrain && CUDA_VISIBLE_DEVICES=5 python3 cli.py --train_examples 40 --method fedpet --pattern_ids 1 --data_dir ./data/ --model_type bert --model_name_or_path bert-base-uncased --task_name agnews --output_dir /data/cdq/pet/log_fedpet_avg_40_10 --ipet_scale_factor 5 --ipet_generations 100 --pet_num_train_epochs 10 --pet_repetitions 1 --pet_per_gpu_train_batch_size 4 --do_train --do_eval > log_fedpet_avg_40_10.log 2>&1

# conda activate ptpretrain && CUDA_VISIBLE_DEVICES=5 python3 cli.py --train_examples 40 --method fedpet --pattern_ids 1 --data_dir ./data/ --model_type bert --model_name_or_path bert-base-uncased --task_name agnews --output_dir /data/cdq/pet/log_fedpet_voting_avg_40_10 --ipet_scale_factor 5 --ipet_generations 100 --pet_num_train_epochs 10 --pet_repetitions 1 --pet_per_gpu_train_batch_size 4 --do_train --do_eval > log_fedpet_voting_avg_40_10.log 2>&1

# conda activate ptpretrain && CUDA_VISIBLE_DEVICES=6 python3 cli.py --train_examples 40 --method fedpet --pattern_ids 1 --data_dir ./data/ --model_type bert --model_name_or_path bert-base-uncased --task_name agnews --output_dir /data/cdq/pet/log_local_pet_40_10 --ipet_scale_factor 5 --ipet_generations 100 --pet_num_train_epochs 10 --pet_repetitions 1 --pet_per_gpu_train_batch_size 4 --do_train --do_eval > log_local_pet_40_10.log 2>&1

# conda activate ptpretrain && CUDA_VISIBLE_DEVICES=4 python3 cli.py --train_examples 40 --method fedpet --pattern_ids 1 --data_dir ./data/ --model_type bert --model_name_or_path bert-base-uncased --task_name agnews --output_dir /data/cdq/pet/log_local_pet_2_40_10 --ipet_scale_factor 2 --ipet_generations 100 --pet_num_train_epochs 10 --pet_repetitions 1 --pet_per_gpu_train_batch_size 4 --do_train --do_eval > log_local_pet_2_40_10.log 2>&1