package eks_networking

import (
	"github.com/gruntwork-io/terratest/modules/terraform"
	"testing"
)
// basic test - enhance it later
func TestEKSNetworking(t *testing.T){

	tfOptions := &terraform.Options{
		TerraformDir: "./",
		EnvVars: map[string]string{
			"AWS_REGION": "ap-southeast-1",
		},
		Vars: map[string]interface{}{
			"vpc_name" : "eks_vpc",
			"cluster_name": "eks_poc",
			"vpc_cidr_block": "10.0.0.0/16",
			"workers_cidr_block": []string{
				"10.0.0.0/20", "10.0.16.0/20", "10.0.32.0/20",
			},
			"nat_cidr_block": "10.0.48.0/20",
		},
	}

	defer terraform.Destroy(t, tfOptions)

	terraform.InitAndApply(t, tfOptions)

	output := terraform.OutputAll(t, tfOptions)

	t.Logf("%+v", output)

}
