locals {
  iam_groups = {  
    admin = {
      users = ["wnaseeve"]
      policies = {  # Politiques (permissions) attachées au groupe
        AdministratorAccess = "arn:aws:iam::aws:policy/AdministratorAccess"  # Politique AWS d'accès administrateur complet
      }
    }
  }

  iam_users = {
    wnaseeve = {
      force_destroy           = true  # Permet de supprimer l'utilisateur même s'il a des ressources associées
      pgp_key                 = "keybase:wnaseeve"  # Clé PGP pour chiffrer le mot de passe (récupérée depuis Keybase)
      create_login_profile    = true  # Créer un profil de connexion console AWS pour cet utilisateur
      password_reset_required = true  # Obliger l'utilisateur à changer son mot de passe lors de la première connexion
      create_access_key       = true  # Créer une clé d'accès API (Access Key ID et Secret Access Key)
    }
  }
}

module "iam_groups" {
  for_each = local.iam_groups  # Boucle sur chaque groupe défini dans local.iam_groups

  source  = "terraform-aws-modules/iam/aws//modules/iam-group"
  version = "6.2.2"

  name  = each.key  # Nom du groupe (clé de la map : "admin")
  users = each.value.users  # Liste des utilisateurs à ajouter au groupe

  policies = lookup(each.value, "policies", {})  # Recherche les politiques dans la configuration, retourne {} si non trouvées

}

module "iam_users" {
  for_each = local.iam_users

  source  = "terraform-aws-modules/iam/aws//modules/iam-user"
  version = "6.2.2"

  name                    = each.key  # Nom de l'utilisateur (clé de la map : "wnaseeve")
  force_destroy           = lookup(each.value, "force_destroy", false)  # Recherche la valeur de force_destroy, utilise false par défaut
  pgp_key                 = lookup(each.value, "pgp_key", null)  # Recherche la clé PGP, utilise null par défaut
  create_login_profile    = lookup(each.value, "create_login_profile", false)  # Recherche si on doit créer un profil de connexion, utilise false par défaut
  password_reset_required = lookup(each.value, "password_reset_required", false)  # Recherche si le reset du mot de passe est requis, utilise false par défaut
  create_access_key       = lookup(each.value, "create_access_key", false)  # Recherche si on doit créer une clé d'accès API, utilise false par défaut

}
