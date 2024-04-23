import {Constructor, Getter, inject} from '@loopback/core';
import {DefaultCrudRepository, repository} from '@loopback/repository';
import {PgDataSource, ProductDataSource} from '../datasources';
import {Product, ProductRelations} from '../models';
import {
  AuditDbSourceName,
  AuditLogRepository,
  AuditRepositoryMixin,
  IAuditMixinOptions,
} from '@sourceloop/audit-log';
import {AuthenticationBindings} from 'loopback4-authentication';
import {IAuthUserWithPermissions} from '@sourceloop/core';

// export class ProductRepository extends DefaultCrudRepository<
//   Product,
//   typeof Product.prototype.id,
//   ProductRelations
// > {
//   constructor(@inject('datasources.product') dataSource: ProductDataSource) {
//     super(Product, dataSource);
//   }
// }

const auditOpts: IAuditMixinOptions = {
  actionKey: 'product_key',
};

export class ProductRepository extends AuditRepositoryMixin<
  Product,
  typeof Product.prototype.id,
  ProductRelations,
  string,
  Constructor<
    DefaultCrudRepository<
      Product,
      typeof Product.prototype.id,
      ProductRelations
    >
  >
>(DefaultCrudRepository, auditOpts) {
  constructor(
    @inject(`datasources.product`) dataSource: ProductDataSource,
    @inject.getter(AuthenticationBindings.CURRENT_USER)
    public getCurrentUser: Getter<IAuthUserWithPermissions>,
    @repository.getter('AuditLogRepository')
    public getAuditLogRepository: Getter<AuditLogRepository>,
  ) {
    super(Product, dataSource);
  }
}
